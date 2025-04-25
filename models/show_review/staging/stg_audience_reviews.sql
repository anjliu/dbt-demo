{{ config(tags=["stg","show_review_stg"]) }}

with
    audience_reviews as (
        select distinct
            farm_fingerprint(concat(show, rating, review)) as skey,
            cast(show as string) as show_name,
            cast(rating as numeric) as audience_rating,
            cast(review as string) as audience_review
        from {{ source("bigquery_landing", "audience_reviews") }} as audience_reviews
    )
select *
from audience_reviews
