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
  
  SingleSteps.confirmDialog = function(body,  taskDependency, onConfirm, onCancel) {
    var $modal = $('#modal-confirm');
    $modal.find('.prereq-list').html(body); 
    $modal.find('.task-dependency').html(taskDependency);
    
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
  
  SingleSteps.changeCompletion = function(element, taskName, actionType, event) {
    var $form = $(element.form);
    
    if ($(element).hasClass('confirmed')) {
      $(element).removeClass('confirmed');
      // And continue with default actions w/out checking prereq chain
      return true;
    }
    var $checkbox = $form.find('input[type=checkbox]');
    var checkPreReqs = actionType == 'complete' || actionType == 'include';    
    var $dependencies = null;
    var taskDependency = taskName + ' is related to';
    if (actionType=='include') {
      taskDependency = taskName + ' depends on the following excluded tasks:'
      $dependencies = element.form ? $form.find('.incomplete-prereqs') : $(element).siblings('.excluded-prereqs');      
    } else if (actionType=='complete') {
      taskDependency = taskName + " depends on the following tasks, which aren't complete or haven't been selected:"
      $dependencies = element.form ? $form.find('.incomplete-prereqs') : $(element).siblings('.incomplete-prereqs');
    } else if (actionType == 'exclude') {
      //Check included dependencies   
      taskDependency = 'The following active or completed tasks depend on ' + taskName + ':'
      $dependencies = element.form ? $form.find('.included-dependencies') : $(element).siblings('.included-dependencies');   
    } else {
      //actionType == 'inprogress'
      //Check completed dependencies
      taskDependency = 'The following completed tasks depend on ' + taskName + ':'
      $dependencies = element.form ? $form.find('.complete-dependencies') : $(element).siblings('.complete-dependencies');   
    }
    
    var numIncomplete = $dependencies ? parseInt($dependencies.data('count') || 0) : 0;
    if (numIncomplete > 0) {
      /// only stop if there's no form
      if (!element.form) {
        event.stopPropagation();
        event.preventDefault();                      
      }
      SingleSteps.confirmDialog($dependencies.html(), taskDependency, function(element) {
        SingleSteps.showWait(); 
        SingleSteps.continueAction(element, event);
        return true;
      }.bind(this, element), function($checkbox, element) {
        // set to original state
        $checkbox.prop('checked', !$checkbox.prop('checked'));    
        return false;       
      }.bind(this, $checkbox, element))
    } else {
      SingleSteps.showWait(); 
      SingleSteps.continueAction(element, event);
      return true;
    }
  }
  
  SingleSteps.continueAction = function(element, event) {
    if (element.form) {
      $(element.form).trigger('submit.rails');      
    } else {
      $(element).addClass('confirmed')
      $(element).trigger('click');
    }
  }
  
  
  
}).call(this);

