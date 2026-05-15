from dagster import Definitions
from assets.ingestion import raw_training_dataset, curated_training_dataset

defs = Definitions(assets=[raw_training_dataset, curated_training_dataset])
