import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

# Load the dataset
file_path = "consolidated_questions_dataset.csv"
df = pd.read_csv(file_path)

# Encode categorical variables
le_title = LabelEncoder()
df["title_encoded"] = le_title.fit_transform(df["title"])

le_company = LabelEncoder()
df["company_encoded"] = le_company.fit_transform(df["companies"])

le_topics = LabelEncoder()
df["topics_encoded"] = le_topics.fit_transform(df["related_topics"])

# Feature selection
X = df[["company_encoded", "frequency", "topics_encoded"]]
y = df["title_encoded"]

# Standardize features
scaler = StandardScaler()
X = scaler.fit_transform(X)

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train Logistic Regression with increased iterations and saga solver
lr_model = LogisticRegression(max_iter=1000, solver='saga', random_state=42)
lr_model.fit(X_train, y_train)

# Predict
y_pred = lr_model.predict(X_test)

# Calculate metrics
lr_metrics = {
    "Accuracy": accuracy_score(y_test, y_pred),
    "Precision": precision_score(y_test, y_pred, average="weighted", zero_division=0),
    "Recall": recall_score(y_test, y_pred, average="weighted"),
    "F1-Score": f1_score(y_test, y_pred, average="weighted")
}

# Print metrics
print(lr_metrics)