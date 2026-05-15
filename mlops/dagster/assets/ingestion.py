from dagster import asset

@asset(group_name="ml_landing_zone")
def raw_training_dataset() -> list[dict]:
    """Exemple simple d'ingestion; remplacer par S3/DB/Feature Store."""
    return [
        {"id": 1, "feature": 0.12, "label": 0},
        {"id": 2, "feature": 0.91, "label": 1},
    ]

@asset(group_name="ml_landing_zone")
def curated_training_dataset(raw_training_dataset: list[dict]) -> list[dict]:
    return [row for row in raw_training_dataset if "feature" in row and "label" in row]
