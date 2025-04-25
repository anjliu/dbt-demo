{{ config(tags=["stg","show_review_stg"]) }}

with
    critic_reviews as (
        select distinct
            farm_fingerprint(concat(show, sentiment, review)) as skey,
            cast(show as string) as show_name,
            cast(sentiment as int64) as critic_sentiment,
            cast(review as string) as critic_review
        from {{ source("bigquery_landing", "critic_reviews") }}
    )
select *
from critic_reviews
