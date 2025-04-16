{{ config(
    schema = "transform",
    tags=["show_review_cleaning"]
    ) }}


SELECT
  CAST(show AS string) AS show_name,
  CAST(rating AS numeric) AS audience_rating,
  CAST(review AS string) AS audience_review,
  current_timestamp() as created_timestamp
FROM
  {{source("bigquery_landing","audience_review")}}