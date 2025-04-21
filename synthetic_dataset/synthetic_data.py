import pandas as pd
from ctgan import CTGAN
from sklearn.preprocessing import LabelEncoder

# Load the original dataset (10K real entries)
df = pd.read_csv('real_questions_dataset.csv')

# Identify categorical columns
categorical_columns = df.select_dtypes(include=[object]).columns
label_encoders = {col: LabelEncoder() for col in categorical_columns}

# Apply label encoding to categorical columns
for col, encoder in label_encoders.items():
    df[col] = encoder.fit_transform(df[col])

# Initialize CTGAN model
model = CTGAN(epochs=500)
model.fit(df, discrete_columns=categorical_columns)

# File to store synthetic data (avoiding overwrite of original dataset)
synthetic_file = 'Expanded_Synthetic_Questions_Dataset.csv'

batch_size = 3785
total_batches = 14  # To reach 50,000 entries
start_id = len(df) + 1  # Serial No. starts after real dataset

all_synthetic_data = []  # Store all batches before writing to a single file

for batch in range(total_batches):
    print(f"Generating batch {batch + 1} of {total_batches}...")

    # Generate synthetic batch
    generated_data = model.sample(batch_size)

    # Add order numbers to maintain sequence
    # Ensure "Serial No." column does not exist before inserting
    if "Serial No." in generated_data.columns:
     generated_data = generated_data.drop(columns=["Serial No."])

    generated_data.insert(0, "Serial No.", range(start_id, start_id + batch_size))
    start_id += batch_size

    # Reverse label encoding
    for col, encoder in label_encoders.items():
        generated_data[col] = encoder.inverse_transform(generated_data[col].astype(int))

    # Append to list (store in memory before writing once)
    all_synthetic_data.append(generated_data)

# Combine all batches and save to a single file
final_synthetic_df = pd.concat(all_synthetic_data, ignore_index=True)
final_synthetic_df.to_csv("synthetic_questions_dataset.csv", index=False)

print("Synthetic dataset with 50,000 entries generated successfully!")