class MessageCounter

  constructor: (interval, $messageCounter)->
    @interval = interval
    @$messageCounter = $messageCounter

    self = @
    setInterval (->
      self.updateCounter()
    ), interval


  updateCounter: ->
    self = @
    $.ajax
      url: '/contacts/amount_unread_message'
      success: (data) ->
        count = data.unread_message_count
        if count == 0
          self.$messageCounter.hide()
        else
          self.$messageCounter.show()
          self.$messageCounter.html(count)


$ ->
  $messageCounter = $('[data-behaviour~=update-counters]')

  if $messageCounter.length
    new MessageCounter(10000, $messageCounter)
