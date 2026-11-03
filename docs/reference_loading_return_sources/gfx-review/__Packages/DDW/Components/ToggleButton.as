class DDW.Components.ToggleButton extends DDW.Components.DefaultButton
{
   var gotoAndStop;
   var graphics;
   var isCursorActive;
   var isDown;
   var isDragable;
   var isTransformHover;
   var outColor;
   var parent;
   var sendClickMessage;
   var totalFrames;
   var _isDown = false;
   function ToggleButton(libraryName, mx)
   {
      super(libraryName,mx);
      this.isDragable = false;
      this.isTransformHover = true;
   }
   function setButtonState(state)
   {
      this.isDown = state;
      this.drawButtonState();
   }
   function clickButton()
   {
      if(this.isCursorActive())
      {
         this.isDown = !this.isDown;
         this.drawButtonState();
      }
   }
   function releaseButton()
   {
      if(this.isCursorActive() && this.parent != null)
      {
         this.sendClickMessage();
         this.drawButtonState();
      }
   }
   function stopButton()
   {
      if(!this.isTransformHover && this.totalFrames > 1)
      {
         this.drawButtonState();
      }
      else
      {
         this.graphics.transform.colorTransform = this.outColor;
      }
   }
   function drawButtonState()
   {
      if(this.isDown)
      {
         if(this.totalFrames > 1)
         {
            this.gotoAndStop(2);
         }
         if(this.isTransformHover)
         {
            this.graphics.transform.colorTransform = null;
         }
      }
      else
      {
         this.gotoAndStop(1);
         this.graphics.transform.colorTransform = null;
      }
   }
}
