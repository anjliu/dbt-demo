-- dbt's programming and best-practice recommendations create different schemas for each user,
-- by concatenating the user's profile name and any customized schema names specified in the model
-- while this is a good idea in dev environments, prod (and prod-like) environments would need to have a unified schema structure
-- this script removes the default concatenation behaviour in prod environments
-- the env_var function grabs the value of a user-set environment variable as the first arugment and takes an optional second argument as the default value

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- elif  env_var('DBT_ENV_TYPE','DEV') == 'PROD' -%}
        
        {{ custom_schema_name | trim }}
    
    {%- elif  env_var('DBT_ENV_TYPE','DEV') == 'STG' -%}
        
        {{ custom_schema_name | trim }}

    {%- else -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}