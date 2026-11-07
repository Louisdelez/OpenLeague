class DDW.Components.DefaultButton extends DDW.Components.DisplayObjectContainer
{
   var _baseEventsCreated;
   var _isDisposing;
   var _wasDragging;
   var addEventListener;
   var children;
   var enabled;
   var gotoAndStop;
   var graphics;
   var hitTest;
   var id;
   var parent;
   var removeEventListener;
   var totalFrames;
   var visible;
   static var currentHoveringButton;
   var isTransformHover = false;
   var useHitTest = false;
   var isOver = false;
   var isDown = false;
   var overPrefix = "RollOver_";
   var pressPrefix = "Press_";
   var releasePrefix = "Release_";
   var outPrefix = "RollOut_";
   var rightClickPrefix = "RightClick_";
   var _commName = "";
   var commEnabled = true;
   var overMsg = "";
   var pressMsg = "";
   var releaseMsg = "";
   var outMsg = "";
   var overColor = new flash.geom.ColorTransform(1,1,1,1,50,50,50,0);
   var outColor = new flash.geom.ColorTransform(1,1,1,1,0,0,0,0);
   var disabledOnFrameFour = false;
   var _class = "DefaultButton";
   var _hoverOnly = false;
   function DefaultButton(libraryName, mx)
   {
      super(libraryName,mx);
      this.addEventListener(DDW.Events.Event.ADDED_TO_STAGE,this,this.addedToStage);
      this.isOver = false;
   }
   function get commName()
   {
      return this._commName;
   }
   function set commName(value)
   {
      if(value != null && value != "")
      {
         this.commEnabled = true;
      }
      else
      {
         this.commEnabled = false;
      }
      this._commName = value;
      this.overMsg = value;
      this.pressMsg = value;
      this.releaseMsg = value;
      this.outMsg = value;
   }
   function setEnabled(value)
   {
      if(value == 0)
      {
         this.disable();
      }
      else
      {
         this.enable();
      }
   }
   function hoverOnly(value)
   {
      this._hoverOnly = value;
      this.graphics.enabled = true;
   }
   function enable()
   {
      this.enabled = true;
      this.graphics.enabled = true;
      if(this.disabledOnFrameFour)
      {
         this.graphics.gotoAndStop(1);
      }
      else
      {
         this.graphics._alpha = 100;
      }
   }
   function disable()
   {
      this.stopButton();
      this.enabled = false;
      this.isOver = false;
      if(this.disabledOnFrameFour)
      {
         this.graphics.gotoAndStop(4);
      }
      else
      {
         this.graphics._alpha = 50;
      }
      if(!this._hoverOnly)
      {
         this.graphics.enabled = false;
      }
      else
      {
         this.graphics.enabled = true;
      }
   }
   function click(event)
   {
      if(this.enabled && this.isCursorActive())
      {
         DDW.Communication.Comm.send("GenericClick");
         this.clickButton();
      }
   }
   function release(event)
   {
      if(this.enabled && this.isCursorActive())
      {
         this.releaseButton();
      }
   }
   function rollOver(event)
   {
      trace("rollOver");
      if((this._hoverOnly || this.enabled) && (this.isCursorActive() && (!this.isOver && (this.parent != null && !this._wasDragging))))
      {
         currentHoveringButton = this;
         if(this.commEnabled && !this.isOver)
         {
            DDW.Communication.Comm.send(this.overPrefix + this.overMsg);
         }
         if(!this._hoverOnly)
         {
            this.playButton();
         }
         this.isOver = true;
      }
   }
   function rollOut(event)
   {
      var _loc3_ = true;
      if(this.useHitTest)
      {
         _loc3_ = !this.hitTest(_root._xmouse,_root._ymouse,true,true);
      }
      var _loc4_;
      if(_loc3_ && !this._wasDragging)
      {
         if(this.isCursorActive() && this.parent != null)
         {
            if(this.commEnabled && this.isOver)
            {
               DDW.Communication.Comm.send(this.outPrefix + this.outMsg);
            }
            if(!this._hoverOnly)
            {
               this.stopButton();
            }
            _global.closeTooltip();
         }
         _loc4_ = 0;
         while(_loc4_ < this.children.length)
         {
            if(this.children[_loc4_].rollOut != null)
            {
               this.children[_loc4_].rollOut(event);
            }
            _loc4_ = _loc4_ + 1;
         }
         if(currentHoveringButton != null && currentHoveringButton.id == this.id)
         {
            currentHoveringButton = null;
         }
         this.isOver = false;
      }
   }
   function onRightClick()
   {
      if(this.commEnabled && (this.pressMsg != null && this.pressMsg != ""))
      {
         DDW.Communication.Comm.send(this.rightClickPrefix + this.pressMsg);
      }
      else
      {
         DDW.Communication.Comm.send("");
      }
   }
   function addedToStage(event)
   {
      super.addedToStage();
      this.enabled = true;
      this.addBaseEvents();
   }
   function removedFromStage(event)
   {
      super.removedFromStage();
      this.enabled = false;
      this.removeBaseEvents();
      this.graphics = null;
   }
   function addBaseEvents()
   {
      if(!this._baseEventsCreated)
      {
         this._baseEventsCreated = true;
         super.addBaseEvents();
         this.addEventListener(DDW.Events.MouseEvent.PRESS,this,this.click);
         this.addEventListener(DDW.Events.MouseEvent.RELEASE,this,this.release);
         this.addEventListener(DDW.Events.MouseEvent.RELEASE_OUTSIDE,this,this.release);
         this.addEventListener(DDW.Events.MouseEvent.ROLL_OVER,this,this.rollOver);
         this.addEventListener(DDW.Events.MouseEvent.ROLL_OUT,this,this.rollOut);
         this.addEventListener(DDW.Events.MouseEvent.DRAG_OUT,this,this.rollOut);
      }
   }
   function removeBaseEvents()
   {
      super.removeBaseEvents();
      this.removeEventListener(DDW.Events.MouseEvent.PRESS,this.click);
      this.removeEventListener(DDW.Events.MouseEvent.RELEASE,this.release);
      this.removeEventListener(DDW.Events.MouseEvent.RELEASE_OUTSIDE,this.release);
      this.removeEventListener(DDW.Events.MouseEvent.ROLL_OVER,this.rollOver);
      this.removeEventListener(DDW.Events.MouseEvent.ROLL_OUT,this.rollOut);
      this.removeEventListener(DDW.Events.MouseEvent.DRAG_OUT,this.rollOut);
   }
   function playButton()
   {
      if(!this.isTransformHover && this.totalFrames > 1)
      {
         this.gotoAndStop(2);
      }
      else
      {
         this.graphics.transform.colorTransform = this.overColor;
         this.graphics._visible = this.visible;
      }
   }
   function stopButton()
   {
      if(!this.isTransformHover && this.totalFrames > 1)
      {
         this.gotoAndStop(1);
      }
      else
      {
         this.graphics.transform.colorTransform = this.outColor;
         this.graphics._visible = this.visible;
      }
   }
   function clickButton()
   {
      if(this.isCursorActive())
      {
         if(!this.isTransformHover && this.totalFrames > 2)
         {
            this.gotoAndStop(3);
         }
         else if(this.isTransformHover)
         {
            this.graphics.transform.colorTransform = null;
         }
         this.isDown = true;
      }
   }
   function releaseButton()
   {
      if(this.isCursorActive() && this.parent != null)
      {
         this.sendClickMessage();
         if(!this.isTransformHover && this.totalFrames > 1)
         {
            this.gotoAndStop(1);
         }
         else
         {
            this.graphics.transform.colorTransform = null;
         }
         this.isDown = false;
      }
   }
   function sendClickMessage()
   {
      if(this.commEnabled && !this._wasDragging)
      {
         DDW.Communication.Comm.send(this.pressPrefix + this.pressMsg);
      }
   }
   function dragMouseDown(obj, e)
   {
      super.dragMouseDown(obj,e);
   }
   function dragMouseUp(obj, e)
   {
      super.dragMouseUp(obj,e);
   }
   function isCursorActive()
   {
      return true;
   }
   function dispose()
   {
      if(!this._isDisposing)
      {
         this._isDisposing = true;
         this.removeEventListener(DDW.Events.MouseEvent.PRESS,this.click);
         this.removeEventListener(DDW.Events.MouseEvent.RELEASE,this.release);
         this.removeEventListener(DDW.Events.MouseEvent.RELEASE_OUTSIDE,this.release);
         this.removeEventListener(DDW.Events.MouseEvent.ROLL_OVER,this.rollOver);
         this.removeEventListener(DDW.Events.MouseEvent.ROLL_OUT,this.rollOut);
         this.removeEventListener(DDW.Events.MouseEvent.DRAG_OUT,this.rollOut);
         this.removeEventListener(DDW.Events.Event.ADDED_TO_STAGE,this.addedToStage);
      }
   }
}
