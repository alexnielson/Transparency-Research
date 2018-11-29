# Author comment and file description ####

# Code written by Michael Jensen.

# Purpose:
# Browse an entity's Transparency data.

# Connect to AWS ####
library(RODBC)
aws <- odbcConnect("transpAWS")

# Define the entity's Transparency ID ####
id <- sqlQuery(aws, paste("SELECT id, name FROM entity"))
t.id <- 1227
rm(id)

# Get the entity's information ####
# Entity template:
entity <- sqlQuery(aws, paste("
                              SELECT id, name, govt_lvl, fiscal_period,
                                     payroll_period
                              FROM entity
                              WHERE id = ", t.id))

# Copy the entity template and paste below to customize request.

# Get the entity's batches ####
# Batch template:
batch <- sqlQuery(
  aws, 
  paste("
        SELECT id, begin_txn_date, end_txn_date, upload_username, upload_date, 
               processed_date, status, status_message
        FROM batch
        WHERE entity_id = ", t.id))

# Copy the batch template and paste below to customize request.

# Get the entity's expense transactions ####
# Expense template:
exp <- sqlQuery(
  aws,
  paste("
        SELECT id, posting_date, amount, fiscal_year, type
        FROM transaction
        WHERE batch_id
        IN (
          SELECT id
          FROM batch
          WHERE entity_id = ", t.id, "
          AND status IN ('PROCESSED', 'PROCESSING'))
        AND type = 1"))

# Copy the expense template and paste below to customize request.

# Get the entity's revenue transactions ####
# Revenue template:
rev <- sqlQuery(
  aws,
  paste("
        SELECT id, posting_date, amount, fiscal_year, type
        FROM transaction
        WHERE batch_id
        IN (
          SELECT id
          FROM batch
          WHERE entity_id = ", t.id, "
          AND status IN ('PROCESSED', 'PROCESSING'))
        AND type = 2"))

# Copy the revenue template and paste below to customize request.

# Get the entity's compensation transactions ####
# Compensation template:
comp <- sqlQuery(
  aws,
  paste("
        SELECT id, posting_date, amount, fiscal_year, type
        FROM transaction
        WHERE batch_id
        IN (
          SELECT id
          FROM batch
          WHERE entity_id = ", t.id, "
          AND status IN ('PROCESSED', 'PROCESSING'))
        AND type = 3"))

# Copy the compensation template and paste below to customize request.

# Clear the R environment ####
odbcClose(aws)
detach(package:RODBC)
rm(aws, t.id, entity, batch, exp, rev, comp)