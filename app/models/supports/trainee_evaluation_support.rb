class Supports::TraineeEvaluationSupport
  attr_reader :trainee_evaluation, :targetable, :evaluation_template

  def initialize args
    @trainee_evaluation = args[:trainee_evaluation]
    @targetable = args[:targetable]
    @filter_service = args[:filter_service]
    @namespace = args[:namespace]
    @current_user = args[:current_user]
    @evaluation_template = args[:evaluation_template]
  end

  def evaluation_standards
    @evaluation_standards ||= EvaluationStandard.all
  end

  def evaluation_templates
    @evaluation_templates ||= EvaluationTemplate.all.collect {|object| [object.name,
      object.id]}
  end

  def nonselected_standards
    @nonselected_standards ||= @trainee_evaluation
      .evaluation_template.evaluation_standards - @trainee_evaluation.evaluation_standards
  end

  def trainee_evaluations
    @trainee_evaluations ||= TraineeEvaluation.includes :user
  end

  def filter_data_user
    @filter_data_user ||= @filter_service.user_filter_data
  end

  def trainee_evaluation_presenters
    @trainee_evaluation_presenters ||= TraineeEvaluationPresenter.new(namespace:
      @namespace, trainee_evaluations: trainee_evaluations,
      current_user: @current_user).render
  end
end
