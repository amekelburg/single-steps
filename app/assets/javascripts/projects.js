//= require_self

(function() {
  this.SingleSteps || (this.SingleSteps = {});

  SingleSteps.showWait = function() {
    $('#modal-wait').modal({
      backdrop: 'static',
      keyboard: false
    })
  }
}).call(this);
