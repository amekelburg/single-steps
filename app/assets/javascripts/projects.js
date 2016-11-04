//= require_self

(function() {
  this.SingleSteps || (this.SingleSteps = {});

  SingleSteps.showWait = function() {
    $('#modal-wait').modal({
      backdrop: 'static',
      keyboard: false
    })
  }
  SingleSteps.hideWait = function() {
    $('#modal-wait').modal('hide')
  }  
  
  SingleSteps.confirmDialog = function(body, onConfirm, onCancel) {
    var $modal = $('#modal-confirm');
    $modal.find('.prereq-list').html(body)    
    $modal.modal({
      backdrop: 'static',
      keyboard: false
    })
    
    var cancelHandler = function($modal, onCancel, e) {
      $modal.off('click', '.btn-cancel');
      onCancel();
    }.bind(this, $modal, onCancel);
    
    $modal.on('click', '.btn-cancel', cancelHandler)
    
    var confirmHandler = function($modal, onConfirm, e) {
      $modal.off('click', '.btn-submit');
      $modal.modal('hide')
      onConfirm();       
    }.bind(this, $modal, onConfirm)
    
    $modal.on('click', '.btn-submit', confirmHandler);
  }
  
  SingleSteps.changeCompletion = function(form) {
    var $form = $(form)
    var $checkbox = $form.find('input[type=checkbox]');
    var isCompletingTask = $checkbox.is(':checked');
    if (isCompletingTask) {
      var $incompletePreReqs = $form.find('.incomplete-prereqs');
      var numIncomplete = $incompletePreReqs ? parseInt($incompletePreReqs.data('count') || 0) : 0;
      if (numIncomplete > 0) {
        SingleSteps.confirmDialog($incompletePreReqs.html(), function($form) {
          SingleSteps.showWait(); 
          console.log($form);
          SingleSteps.submitForm($form);
        }.bind(this, $form), function($checkbox) {
          $checkbox.attr('checked', false);           
        }.bind(this, $checkbox))
      } else {
        SingleSteps.showWait(); 
        SingleSteps.submitForm($form);
      }
    } else {
      SingleSteps.showWait(); 
      SingleSteps.submitForm($form);
    }  
  }
  
  SingleSteps.submitForm = function($form) {
    $form.trigger('submit.rails');
  }
  
  
}).call(this);

