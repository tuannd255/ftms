class AddEvaluationTemplateToTraineeEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :trainee_evaluations, :evaluation_template_id, :integer
  end
end
