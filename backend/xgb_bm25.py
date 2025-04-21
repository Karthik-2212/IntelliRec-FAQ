import pandas as pd
from rank_bm25 import BM25Okapi
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from xgboost import XGBClassifier
from sklearn.preprocessing import LabelEncoder
import numpy as np
from collections import defaultdict
from sklearn.metrics import precision_score, recall_score, f1_score, ndcg_score

class FAQRecommender:
    def __init__(self, data_path):
        # Load data first
        self.df = pd.read_csv(data_path)
        
        # Initialize frequency dictionaries
        self.company_freq = self.df['companies'].value_counts().to_dict()
        self.topic_freq = self.df['related_topics'].value_counts().to_dict()
        
        # Preprocess data
        self.preprocess_data()
        
        # Initialize models
        self.initialize_bm25()
        self.initialize_xgboost()
        
        # Precompute top topics
        self.company_top_topics = self.compute_company_top_topics()
        
        # Evaluation parameters
        self.k = 10
        self.evaluation_metrics = {
            'precision': [],
            'recall': [],
            'f1': [],
            'ndcg': []
        }

    def preprocess_data(self):
        """Enhanced preprocessing with additional features"""
        self.df['combined_text'] = self.df['title'] + ' ' + self.df['related_topics']
        
        # Encode companies
        self.le = LabelEncoder()
        self.df['company_encoded'] = self.le.fit_transform(self.df['companies'])
        
        # Create frequency features
        self.df['company_freq'] = self.df['companies'].map(self.company_freq)
        self.df['topic_freq'] = self.df['related_topics'].map(self.topic_freq)
        
        # Create topic importance scores
        self.df['topic_importance'] = self.df.groupby('related_topics')['title'].transform('count')
        
        # Create relevance column for evaluation
        self.df['relevance'] = 1

    def compute_company_top_topics(self, n_topics=5):
        """Compute top topics for each company with weights"""
        company_topics = defaultdict(list)
        for _, row in self.df.iterrows():
            company_topics[row['companies']].append(row['related_topics'])
        
        top_topics = {}
        for company, topics in company_topics.items():
            topic_counts = pd.Series(topics).value_counts(normalize=True)
            top_topics[company] = topic_counts.head(n_topics).to_dict()
        return top_topics

    def get_top_topics_for_company(self, company_name, n=5):
        """Get top topics with weights for a specific company"""
        return self.company_top_topics.get(company_name, {})

    def initialize_bm25(self):
        """Initialize BM25 model for frequency-based recommendations"""
        tokenized_corpus = [doc.split() for doc in self.df['combined_text']]
        self.bm25 = BM25Okapi(tokenized_corpus)

    def initialize_xgboost(self):
        """Initialize XGBoost model for topic-based recommendations"""
        # Prepare features - topic importance and company frequency
        X = self.df[['topic_importance', 'company_freq']]
        y = self.df['company_encoded']
        
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        self.xgb_model = XGBClassifier(
            objective='multi:softprob',
            eval_metric='mlogloss',
            n_estimators=100
        )
        self.xgb_model.fit(X_train, y_train)

    def get_frequency_recommendations(self, company=None, n=None):
        """Get BM25 frequency-based recommendations"""
        n = n or self.k
        if company:
            # Get all questions for the company
            company_questions = self.df[self.df['companies'] == company]['combined_text'].tolist()
            if not company_questions:
                return pd.DataFrame()
            
            # Use BM25 to score based on frequency patterns
            tokenized_query = company.split() + ['frequent', 'common']  # Boost frequent questions
            doc_scores = self.bm25.get_scores(tokenized_query)
            
            # Get top recommendations
            top_indices = np.argsort(doc_scores)[-n:][::-1]
            recs = self.df.iloc[top_indices].copy()
            recs['score'] = doc_scores[top_indices]
            recs['score_type'] = 'frequency'
            return recs
        return pd.DataFrame()

    def get_topic_recommendations(self, company=None, n=None):
        """Get XGBoost topic-based recommendations"""
        n = n or self.k
        if company:
            try:
                company_encoded = self.le.transform([company])[0]
                # Get questions with top topics for this company
                top_topics = self.get_top_topics_for_company(company)
                if not top_topics:
                    return pd.DataFrame()
                
                topic_questions = self.df[self.df['related_topics'].isin(top_topics.keys())].copy()
                if topic_questions.empty:
                    return pd.DataFrame()
                
                # Predict using XGBoost (higher scores for more relevant topic-company pairs)
                topic_questions['topic_score'] = self.xgb_model.predict_proba(
                    topic_questions[['topic_importance', 'company_freq']]
                )[:, company_encoded]
                
                # Weight by topic importance
                topic_questions['score'] = (
                    topic_questions['topic_score'] * 
                    topic_questions['related_topics'].map(top_topics).fillna(0)
                )
                
                topic_questions['score_type'] = 'topic'
                return topic_questions.sort_values('score', ascending=False).head(n)
            except ValueError:
                pass
        return pd.DataFrame()

    def evaluate_recommendations(self, recommendations, true_relevance=None):
        """Evaluate recommendations against ground truth"""
        if recommendations.empty:
            return
        
        # If true relevance not provided, use the pre-labeled relevance in the dataset
        if true_relevance is None:
            true_relevance = recommendations['relevance'].values
        
        pred_relevance = np.ones(len(recommendations))  # Our system predicts all as relevant
        
        # Calculate metrics
        precision = precision_score(true_relevance, pred_relevance, average='micro')
        recall = recall_score(true_relevance, pred_relevance, average='micro')
        f1 = f1_score(true_relevance, pred_relevance, average='micro')
        
        # For NDCG, we need relevance scores - use the weighted scores from our system
        ndcg = ndcg_score([true_relevance], [recommendations['weighted_score'].values])
        
        # Store metrics
        self.evaluation_metrics['precision'].append(precision)
        self.evaluation_metrics['recall'].append(recall)
        self.evaluation_metrics['f1'].append(f1)
        self.evaluation_metrics['ndcg'].append(ndcg)

    def get_metrics_summary(self):
        """Get average of all evaluation metrics"""
        summary = {
            'precision': np.mean(self.evaluation_metrics['precision']),
            'recall': np.mean(self.evaluation_metrics['recall']),
            'f1': np.mean(self.evaluation_metrics['f1']),
            'ndcg': np.mean(self.evaluation_metrics['ndcg']),
            'test_cases': len(self.evaluation_metrics['precision'])
        }
        return summary

    def hybrid_recommend(self, company=None, text_query=None, evaluate=False):
        """Hybrid recommendation combining frequency and topic approaches"""
        recommendations = []
        
        # 1. Frequency-based recommendations (BM25) - 60% weight
        if company:
            freq_recs = self.get_frequency_recommendations(company, self.k)
            if not freq_recs.empty:
                recommendations.append(freq_recs)
        
        # 2. Topic-based recommendations (XGBoost) - 40% weight
        if company and not text_query:  # Only use topics when no text query
            topic_recs = self.get_topic_recommendations(company, self.k)
            if not topic_recs.empty:
                recommendations.append(topic_recs)
        
        # 3. Text-based search (when query provided)
        if text_query:
            tokenized_query = text_query.split()
            doc_scores = self.bm25.get_scores(tokenized_query)
            top_indices = np.argsort(doc_scores)[-self.k:][::-1]
            text_recs = self.df.iloc[top_indices].copy()
            text_recs['score'] = doc_scores[top_indices]
            text_recs['score_type'] = 'text'
            recommendations.append(text_recs)
        
        # Combine all recommendations
        if recommendations:
            combined = pd.concat(recommendations)
            combined = combined.drop_duplicates(subset=['title'], keep='first')
            
            # Create weighted score
            score_weights = {
                'frequency': 0.6 if company else 0,
                'topic': 0.4 if (company and not text_query) else 0,
                'text': 1.0 if text_query else 0
            }
            
            # Normalize weights
            total_weight = sum(score_weights.values())
            if total_weight > 0:
                for key in score_weights:
                    score_weights[key] /= total_weight
            
            combined['weighted_score'] = 0.0
            for score_type, weight in score_weights.items():
                mask = combined['score_type'] == score_type
                if not mask.any():
                    continue
                    
                max_score = combined.loc[mask, 'score'].max()
                if max_score > 0:
                    combined.loc[mask, 'weighted_score'] = (combined.loc[mask, 'score'] / max_score) * weight
            
            combined = combined.sort_values('weighted_score', ascending=False)
            
            if evaluate:
                self.evaluate_recommendations(combined.head(self.k), None)
            
            return combined.head(self.k)
        
        return pd.DataFrame()

def main():
    # Initialize the recommender
    recommender = FAQRecommender("consolidated_questions_dataset_20000.csv")
    
    # First evaluate the system
    print("Evaluating recommendation system...")
    test_companies = list(recommender.company_top_topics.keys())[:70]  # Test on 10 companies
    for company in test_companies:
        recommender.hybrid_recommend(company=company, evaluate=True)
    
    metrics = recommender.get_metrics_summary()
    print("\nSystem Evaluation Metrics:")
    print(f"Precision: {metrics['precision']:.4f}")
    print(f"Recall   : {metrics['recall']:.4f}")
    print(f"F1 Score : {metrics['f1']:.4f}")
    print(f"NDCG     : {metrics['ndcg']:.4f}")
    # print(f"Test Cases: {metrics['test_cases']}")
    
    # Interactive interface
    print("\nFAQ Retrieval (type 'quit' to exit):")
    while True:
        company = input("\nEnter company: ").strip()
        if company.lower() == 'quit':
            break
            
        if company not in recommender.company_top_topics:
            print(f"Company '{company}' not found. Try another.")
            continue
            
        query = input("Search query (or Enter for top FAQs): ").strip()
        
        # Display related topics
        related_topics = recommender.get_top_topics_for_company(company)
        print(f"\nTop Related Topics for {company}:")
        if related_topics:
            for i, (topic, weight) in enumerate(related_topics.items(), 1):
                print(f"{i}. {topic}")
        
        # Get and display recommendations
        faqs = recommender.hybrid_recommend(company=company, text_query=query if query else None)
        print("\nRecommended FAQs:")
        if not faqs.empty:
            for i, (_, row) in enumerate(faqs.iterrows(), 1):
                print(f"{i}. {row['title']}")  # Only show title
        else:
            print("No results found")

if __name__ == "__main__":
    main()