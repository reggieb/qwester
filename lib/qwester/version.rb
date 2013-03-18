module Qwester
  VERSION = "0.1.0"
end

# History
# =======
# 
# 0.1.0 - Add presentations as a way of controlling the display of questionnaires
#   Allows admin to define groups of questionnaires as presentation views
#   and rule sets that will display a presentation when triggered. In that way 
#   the list of questionnaires being displayed can change as questionnaires are
#   submitted.
# 
# 0.0.9 - maintenance update
#   Removes cope_index from migrations.
#   Ensures answer_store#session_id is unique
# 
# 0.0.8 - add facility to preserve answer stores
#   This allows snaps shots to be taken, and redundant answer stores to be 
#   removed during routine maintenance.
# 
# 0.0.7 - improves deployment process
#   Fixes a bug in one of the migrations and updates the README
# 
# 0.0.6 - bug fix update
#   Fixes issue where error raised if user submits a questionnaire without
#   selecting and answer.
#
# 0.0.5 - bug fix update
#   Fixes issue where active admin rule set form did not include link text field.
#