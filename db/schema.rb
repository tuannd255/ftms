# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170210041817) do

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "key"
    t.text     "parameters",     limit: 65535
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_activities_on_deleted_at", using: :btree
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "answers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",     limit: 65535
    t.boolean  "is_correct"
    t.integer  "question_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["deleted_at"], name: "index_answers_on_deleted_at", using: :btree
    t.index ["question_id"], name: "index_answers_on_question_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "language_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deleted_at"], name: "index_categories_on_deleted_at", using: :btree
    t.index ["language_id"], name: "index_categories_on_language_id", using: :btree
  end

  create_table "ckeditor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
  end

  create_table "comment_hierarchies", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_idx", unique: true, using: :btree
    t.index ["descendant_id"], name: "comment_desc_idx", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",                 limit: 65535
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "parent_id"
    t.integer  "cached_votes_total",                    default: 0
    t.integer  "cached_votes_score",                    default: 0
    t.integer  "cached_votes_up",                       default: 0
    t.integer  "cached_votes_down",                     default: 0
    t.integer  "cached_weighted_score",                 default: 0
    t.integer  "cached_weighted_total",                 default: 0
    t.float    "cached_weighted_average", limit: 24,    default: 0.0
    t.index ["cached_votes_down"], name: "index_comments_on_cached_votes_down", using: :btree
    t.index ["cached_votes_score"], name: "index_comments_on_cached_votes_score", using: :btree
    t.index ["cached_votes_total"], name: "index_comments_on_cached_votes_total", using: :btree
    t.index ["cached_votes_up"], name: "index_comments_on_cached_votes_up", using: :btree
    t.index ["cached_weighted_average"], name: "index_comments_on_cached_weighted_average", using: :btree
    t.index ["cached_weighted_score"], name: "index_comments_on_cached_weighted_score", using: :btree
    t.index ["cached_weighted_total"], name: "index_comments_on_cached_weighted_total", using: :btree
    t.index ["post_id"], name: "index_comments_on_post_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "conversations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_conversations_on_deleted_at", using: :btree
  end

  create_table "course_subject_requirements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "project_requirement_id"
    t.integer "course_subject_id"
    t.index ["course_subject_id"], name: "index_course_subject_requirements_on_course_subject_id", using: :btree
    t.index ["project_requirement_id"], name: "index_course_subject_requirements_on_project_requirement_id", using: :btree
  end

  create_table "course_subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "subject_name"
    t.text     "subject_description", limit: 65535
    t.text     "subject_content",     limit: 65535
    t.string   "image"
    t.integer  "row_order"
    t.integer  "subject_id"
    t.integer  "course_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "deleted_at"
    t.integer  "chatwork_room_id"
    t.integer  "project_id"
    t.string   "link_github"
    t.string   "link_heroku"
    t.index ["course_id"], name: "index_course_subjects_on_course_id", using: :btree
    t.index ["deleted_at"], name: "index_course_subjects_on_deleted_at", using: :btree
    t.index ["project_id"], name: "index_course_subjects_on_project_id", using: :btree
    t.index ["subject_id"], name: "index_course_subjects_on_subject_id", using: :btree
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image"
    t.text     "description", limit: 65535
    t.integer  "status",                    default: 0
    t.integer  "language_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "location_id"
    t.datetime "deleted_at"
    t.integer  "program_id"
    t.integer  "creator_id"
    t.index ["deleted_at"], name: "index_courses_on_deleted_at", using: :btree
    t.index ["program_id"], name: "index_courses_on_program_id", using: :btree
  end

  create_table "daily_post_views", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_id"
    t.integer  "views",      default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["post_id"], name: "index_daily_post_views_on_post_id", using: :btree
  end

  create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "document_link"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "description",       limit: 65535
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_documents_on_deleted_at", using: :btree
  end

  create_table "evaluation_check_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "score",                  limit: 24
    t.integer  "trainee_evaluation_id"
    t.integer  "evaluation_standard_id"
    t.integer  "user_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "name"
    t.boolean  "use",                               default: false
    t.index ["evaluation_standard_id"], name: "index_evaluation_check_lists_on_evaluation_standard_id", using: :btree
    t.index ["trainee_evaluation_id"], name: "index_evaluation_check_lists_on_trainee_evaluation_id", using: :btree
    t.index ["user_id"], name: "index_evaluation_check_lists_on_user_id", using: :btree
  end

  create_table "evaluation_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "evaluation_standard_id"
    t.integer  "evaluation_template_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_evaluation_items_on_deleted_at", using: :btree
    t.index ["evaluation_standard_id"], name: "index_evaluation_items_on_evaluation_standard_id", using: :btree
    t.index ["evaluation_template_id"], name: "index_evaluation_items_on_evaluation_template_id", using: :btree
  end

  create_table "evaluation_standards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.float    "min_point",  limit: 24
    t.float    "max_point",  limit: 24
    t.float    "avarage",    limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_evaluation_standards_on_deleted_at", using: :btree
  end

  create_table "evaluation_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_evaluation_templates_on_deleted_at", using: :btree
  end

  create_table "exams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_subject_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0
    t.integer  "spent_time",      default: 0
    t.datetime "started_at"
    t.integer  "score",           default: 0
    t.integer  "duration"
    t.integer  "user_id"
    t.integer  "category_id"
    t.index ["category_id"], name: "index_exams_on_category_id", using: :btree
    t.index ["deleted_at"], name: "index_exams_on_deleted_at", using: :btree
    t.index ["user_id"], name: "fk_rails_1ef6db8efd", using: :btree
    t.index ["user_subject_id"], name: "index_exams_on_user_subject_id", using: :btree
  end

  create_table "feed_backs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",    limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_feed_backs_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_feed_backs_on_user_id", using: :btree
  end

  create_table "filters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "filter_type"
    t.text     "content",       limit: 65535
    t.integer  "target_id"
    t.boolean  "is_turn_on"
    t.string   "target_params"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["user_id"], name: "index_filters_on_user_id", using: :btree
  end

  create_table "functions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "model_class"
    t.string   "action"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_functions_on_deleted_at", using: :btree
  end

  create_table "languages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.string   "image"
    t.text     "description", limit: 65535
    t.index ["deleted_at"], name: "index_languages_on_deleted_at", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_locations_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_locations_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "content"
    t.integer  "chat_room_id"
    t.string   "chat_room_type"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "notes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "trainee_evaluation_id"
    t.integer  "user_id"
    t.integer  "author_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "deleted_at"
    t.index ["author_id"], name: "index_notes_on_author_id", using: :btree
    t.index ["deleted_at"], name: "index_notes_on_deleted_at", using: :btree
    t.index ["trainee_evaluation_id"], name: "index_notes_on_trainee_evaluation_id", using: :btree
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.integer  "key"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.string   "parameters"
    t.index ["deleted_at"], name: "index_notifications_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "content",                 limit: 65535
    t.integer  "views",                                 default: 0
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "cached_votes_total",                    default: 0
    t.integer  "cached_votes_score",                    default: 0
    t.integer  "cached_votes_up",                       default: 0
    t.integer  "cached_votes_down",                     default: 0
    t.integer  "cached_weighted_score",                 default: 0
    t.integer  "cached_weighted_total",                 default: 0
    t.float    "cached_weighted_average", limit: 24,    default: 0.0
    t.index ["cached_votes_down"], name: "index_posts_on_cached_votes_down", using: :btree
    t.index ["cached_votes_score"], name: "index_posts_on_cached_votes_score", using: :btree
    t.index ["cached_votes_total"], name: "index_posts_on_cached_votes_total", using: :btree
    t.index ["cached_votes_up"], name: "index_posts_on_cached_votes_up", using: :btree
    t.index ["cached_weighted_average"], name: "index_posts_on_cached_weighted_average", using: :btree
    t.index ["cached_weighted_score"], name: "index_posts_on_cached_weighted_score", using: :btree
    t.index ["cached_weighted_total"], name: "index_posts_on_cached_weighted_total", using: :btree
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.date     "start_training_date"
    t.date     "leave_date"
    t.date     "finish_training_date"
    t.date     "contract_date"
    t.string   "naitei_company"
    t.date     "graduation"
    t.integer  "trainee_type_id"
    t.integer  "university_id"
    t.integer  "language_id"
    t.integer  "user_progress_id"
    t.integer  "status_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "location_id"
    t.decimal  "working_day",          precision: 2, scale: 1
    t.datetime "deleted_at"
    t.integer  "stage_id"
    t.string   "staff_code"
    t.date     "join_div_date"
    t.string   "div_name"
    t.datetime "ready_for_project"
    t.datetime "away_date"
    t.datetime "comeback_date"
    t.index ["deleted_at"], name: "index_profiles_on_deleted_at", using: :btree
    t.index ["location_id"], name: "index_profiles_on_location_id", using: :btree
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "program_hierarchies", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "program_anc_desc_idx", unique: true, using: :btree
    t.index ["descendant_id"], name: "program_desc_idx", using: :btree
  end

  create_table "programs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "program_type"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "parent_id"
    t.index ["deleted_at"], name: "index_programs_on_deleted_at", using: :btree
  end

  create_table "project_requirements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id"
    t.text     "name",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "priority"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_project_requirements_on_deleted_at", using: :btree
    t.index ["project_id"], name: "index_project_requirements_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_projects_on_deleted_at", using: :btree
  end

  create_table "questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",     limit: 65535
    t.integer  "level"
    t.integer  "subject_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "category_id"
    t.index ["category_id"], name: "index_questions_on_category_id", using: :btree
    t.index ["deleted_at"], name: "index_questions_on_deleted_at", using: :btree
    t.index ["subject_id"], name: "index_questions_on_subject_id", using: :btree
  end

  create_table "ranks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "begin_point"
    t.integer  "end_point"
    t.float    "rank_value",  limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_ranks_on_deleted_at", using: :btree
  end

  create_table "read_marks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "readable_type", null: false
    t.integer  "readable_id"
    t.string   "reader_type",   null: false
    t.integer  "reader_id"
    t.datetime "timestamp"
    t.index ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", using: :btree
  end

  create_table "results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "exam_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["answer_id"], name: "index_results_on_answer_id", using: :btree
    t.index ["deleted_at"], name: "index_results_on_deleted_at", using: :btree
    t.index ["exam_id"], name: "index_results_on_exam_id", using: :btree
    t.index ["question_id"], name: "index_results_on_question_id", using: :btree
  end

  create_table "role_functions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "role_id"
    t.integer "function_id"
    t.index ["function_id"], name: "index_role_functions_on_function_id", using: :btree
    t.index ["role_id"], name: "index_role_functions_on_role_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "role_type"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at", using: :btree
  end

  create_table "stages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
  end

  create_table "statistics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "month"
    t.integer  "location_id"
    t.integer  "stage_id"
    t.integer  "trainee_type_id"
    t.integer  "language_id"
    t.integer  "total_trainee",   default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["language_id"], name: "index_statistics_on_language_id", using: :btree
    t.index ["location_id"], name: "index_statistics_on_location_id", using: :btree
    t.index ["stage_id"], name: "index_statistics_on_stage_id", using: :btree
    t.index ["trainee_type_id"], name: "index_statistics_on_trainee_type_id", using: :btree
  end

  create_table "statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string   "color"
    t.index ["deleted_at"], name: "index_statuses_on_deleted_at", using: :btree
  end

  create_table "subject_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "subject_id"
    t.integer "category_id"
    t.index ["category_id"], name: "index_subject_categories_on_category_id", using: :btree
    t.index ["subject_id"], name: "index_subject_categories_on_subject_id", using: :btree
  end

  create_table "subject_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "number_of_question"
    t.integer  "time_of_exam"
    t.integer  "min_score_to_pass"
    t.integer  "subject_id"
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "percent_of_questions"
    t.string   "category_questions"
    t.index ["deleted_at"], name: "index_subject_details_on_deleted_at", using: :btree
    t.index ["subject_id"], name: "index_subject_details_on_subject_id", unique: true, using: :btree
  end

  create_table "subject_kick_offs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "content",    limit: 65535
    t.integer  "subject_id"
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["deleted_at"], name: "index_subject_kick_offs_on_deleted_at", using: :btree
    t.index ["subject_id"], name: "index_subject_kick_offs_on_subject_id", using: :btree
  end

  create_table "subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image"
    t.text     "description", limit: 65535
    t.text     "content",     limit: 65535
    t.integer  "during_time"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_subjects_on_deleted_at", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",                       collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "task_masters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.integer  "subject_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_task_masters_on_deleted_at", using: :btree
    t.index ["subject_id"], name: "index_task_masters_on_subject_id", using: :btree
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description",       limit: 65535
    t.integer  "task_master_id"
    t.boolean  "create_by_trainee",               default: false
    t.integer  "course_subject_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.datetime "deleted_at"
    t.index ["course_subject_id"], name: "index_tasks_on_course_subject_id", using: :btree
    t.index ["deleted_at"], name: "index_tasks_on_deleted_at", using: :btree
  end

  create_table "track_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "signin_time"
    t.string   "signin_ip"
    t.datetime "signout_time"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_track_logs_on_user_id", using: :btree
  end

  create_table "trainee_evaluations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "targetable_type"
    t.integer  "targetable_id"
    t.float    "total_point",     limit: 24
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "trainee_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string   "color"
    t.index ["deleted_at"], name: "index_trainee_types_on_deleted_at", using: :btree
  end

  create_table "trainer_programs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "program_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_trainer_programs_on_deleted_at", using: :btree
    t.index ["program_id"], name: "index_trainer_programs_on_program_id", using: :btree
    t.index ["user_id"], name: "index_trainer_programs_on_user_id", using: :btree
  end

  create_table "universities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
    t.string   "abbreviation"
    t.index ["deleted_at"], name: "index_universities_on_deleted_at", using: :btree
  end

  create_table "user_courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "status",     default: 0
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
    t.string   "type"
    t.index ["course_id", "user_id", "type"], name: "index_user_courses_on_course_id_and_user_id_and_type", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_user_courses_on_deleted_at", using: :btree
  end

  create_table "user_functions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "function_id"
    t.string  "type"
    t.index ["function_id"], name: "index_user_functions_on_function_id", using: :btree
    t.index ["user_id"], name: "index_user_functions_on_user_id", using: :btree
  end

  create_table "user_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "seen",            default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.integer  "notification_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_notifications_on_deleted_at", using: :btree
    t.index ["notification_id"], name: "index_user_notifications_on_notification_id", using: :btree
    t.index ["user_id"], name: "index_user_notifications_on_user_id", using: :btree
  end

  create_table "user_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_roles_on_deleted_at", using: :btree
    t.index ["role_id"], name: "index_user_roles_on_role_id", using: :btree
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

  create_table "user_subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "status",               default: 0
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "user_course_id"
    t.integer  "course_subject_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "during_time",          default: 0
    t.integer  "progress",             default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.date     "user_end_date"
    t.boolean  "current_progress",     default: false
    t.datetime "deleted_at"
    t.boolean  "lock_for_create_exam", default: false
    t.boolean  "is_viewed",            default: false
    t.index ["course_id"], name: "index_user_subjects_on_course_id", using: :btree
    t.index ["course_subject_id"], name: "index_user_subjects_on_course_subject_id", using: :btree
    t.index ["deleted_at"], name: "index_user_subjects_on_deleted_at", using: :btree
    t.index ["user_course_id"], name: "index_user_subjects_on_user_course_id", using: :btree
    t.index ["user_id"], name: "index_user_subjects_on_user_id", using: :btree
  end

  create_table "user_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "task_id"
    t.integer  "user_subject_id"
    t.integer  "user_id"
    t.integer  "progress",         default: 0
    t.integer  "status",           default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "deleted_at"
    t.string   "pull_request_url"
    t.integer  "sent_pull_count",  default: 0
    t.index ["deleted_at"], name: "index_user_tasks_on_deleted_at", using: :btree
    t.index ["task_id"], name: "index_user_tasks_on_task_id", using: :btree
    t.index ["user_id"], name: "index_user_tasks_on_user_id", using: :btree
    t.index ["user_subject_id"], name: "index_user_tasks_on_user_subject_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "avatar"
    t.integer  "trainer_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "deleted_at"
    t.string   "type",                   default: "Trainee"
    t.integer  "current_role_type"
    t.string   "chatwork_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "categories", "languages"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "course_subjects", "courses"
  add_foreign_key "course_subjects", "projects"
  add_foreign_key "course_subjects", "subjects"
  add_foreign_key "courses", "programs"
  add_foreign_key "daily_post_views", "posts"
  add_foreign_key "evaluation_check_lists", "evaluation_standards"
  add_foreign_key "evaluation_check_lists", "trainee_evaluations"
  add_foreign_key "evaluation_check_lists", "users"
  add_foreign_key "evaluation_items", "evaluation_standards"
  add_foreign_key "evaluation_items", "evaluation_templates"
  add_foreign_key "exams", "categories"
  add_foreign_key "exams", "user_subjects"
  add_foreign_key "exams", "users"
  add_foreign_key "feed_backs", "users"
  add_foreign_key "filters", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "notes", "trainee_evaluations"
  add_foreign_key "notes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "profiles", "locations"
  add_foreign_key "profiles", "users"
  add_foreign_key "project_requirements", "projects"
  add_foreign_key "questions", "categories"
  add_foreign_key "results", "answers"
  add_foreign_key "results", "exams"
  add_foreign_key "results", "questions"
  add_foreign_key "role_functions", "functions"
  add_foreign_key "role_functions", "roles"
  add_foreign_key "statistics", "languages"
  add_foreign_key "statistics", "locations"
  add_foreign_key "statistics", "stages"
  add_foreign_key "statistics", "trainee_types"
  add_foreign_key "subject_categories", "categories"
  add_foreign_key "subject_categories", "subjects"
  add_foreign_key "subject_kick_offs", "subjects"
  add_foreign_key "task_masters", "subjects"
  add_foreign_key "tasks", "course_subjects", on_delete: :cascade
  add_foreign_key "trainer_programs", "programs"
  add_foreign_key "trainer_programs", "users"
  add_foreign_key "user_notifications", "notifications"
  add_foreign_key "user_notifications", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_subjects", "course_subjects", on_delete: :cascade
  add_foreign_key "user_subjects", "courses"
  add_foreign_key "user_subjects", "user_courses"
  add_foreign_key "user_subjects", "users"
  add_foreign_key "user_tasks", "tasks", on_delete: :cascade
  add_foreign_key "user_tasks", "user_subjects", on_delete: :cascade
  add_foreign_key "user_tasks", "users"
end
