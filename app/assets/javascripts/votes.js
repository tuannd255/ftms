$(document).on('turbolinks:load', function() {
  $(document).on('click', '.cannot-vote', function(e) {
    e.preventDefault();
    alert(I18n.t('qna.votes.cannot_vote'));
  });

  $(document).on('submit', '.form-vote', function(){
    $(this).find('button').prop('disabled', true);
  })
});
