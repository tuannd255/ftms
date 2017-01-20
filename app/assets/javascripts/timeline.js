$(document).on('turbolinks:load', function() {
  if ($('#timeline-embed').length > 0) {
    $.ajax({
      url: '/timelines.json',
      type: 'json',
      method: 'get',
      complete: function(data) {
        createStoryJS({
          type: 'timeline',
          width: '100%',
          height: '600',
          source: '/timelines.json',
          embed_id: 'timeline-embed'
        });
      }
    });
  }
});

var handle_data_timeline = function() {
  $('.vco-timeline .vco-navigation .timenav .content .marker .flag .flag-content').each(function() {
    status = $('span', this).data('status') == undefined ? status = 'finish' :
      $('span', this).data('status');
    $(this).addClass(status + '-background-color');
    $('h3', this).addClass(status + '-color');
  });
  $('#timeline-embed .media').each(function() {
    if (this.offsetHeight < this.scrollHeight) {
      $('.text-media', this).css('border-right', 'none');
    }
  });
  $('#timeline-embed .vco-slider .slider-item .content .content-container .media .media-wrapper .media-container .plain-text .container .user_task').each(function() {
    if ($('.status', this).length == 0) {
      status_class = $('.task', this).data('finish') ? 'glyphicon glyphicon-check' :
        'glyphicon glyphicon-unchecked';
      html = '<div class="status pull-right"><i class="' + status_class + '"></i></div>';
      $(this).append(html);
    }
  });
}
