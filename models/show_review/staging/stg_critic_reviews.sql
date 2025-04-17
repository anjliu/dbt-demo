{{ config(
    tags=["show_review_stg"]
    ) }}

SELECT
  CAST(show AS string) AS show_name,
  CAST(sentiment AS int64) AS critic_sentiment,
  CAST(review AS string) AS critic_review,
  current_timestamp() as created_timestamp
FROM {{ source("bigquery_landing", "critic_reviews") }}