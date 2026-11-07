package blix.components.button
{
   import blix.components.enum.ButtonStatesEnum;
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class ButtonX extends StatefulView implements IDataRenderer
   {
      
      protected var _data:*;
      
      public var autoRepeat:Boolean = false;
      
      public var repeatDelay:uint = 140;
      
      public var repeatInterval:uint = 20;
      
      private var repeatDelayId:int;
      
      private var repeatIntervalId:int;
      
      public var toggleOnClick:Boolean;
      
      protected var _enabledChanged:Signal = new Signal();
      
      protected var _selectedChanged:Signal = new Signal();
      
      protected var _enabled:Boolean;
      
      protected var _selected:Boolean;
      
      protected var _showDownStateOutside:Boolean;
      
      public function ButtonX(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         addEventListener(MouseEvent.CLICK,this.clickHandler);
         setMouseChildren(false);
         this.setEnabled(true);
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         if(!this._enabled)
         {
            param1.stopImmediatePropagation();
            return;
         }
         if(this.toggleOnClick)
         {
            this.setSelected(!this._selected);
         }
         this.refreshState();
      }
      
      public function getEnabledChanged() : ISignal
      {
         return this._enabledChanged;
      }
      
      override public function getEnabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function setEnabled(param1:Boolean) : void
      {
         if(this._enabled == param1)
         {
            return;
         }
         this._enabled = param1;
         setMouseEnabled(this._enabled);
         setButtonMode(this._enabled);
         setUseHandCursor(this._enabled);
         super.setEnabled(this._enabled);
         this.refreshState();
         this._enabledChanged.dispatch(this,this._enabled);
      }
      
      public function getSelectedChanged() : ISignal
      {
         return this._selectedChanged;
      }
      
      public function getSelected() : Boolean
      {
         return this._selected;
      }
      
      public function setSelected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._selectedChanged.dispatch(this,param1);
         this.refreshState();
      }
      
      public function getShowDownStateOutside() : Boolean
      {
         return this._showDownStateOutside;
      }
      
      public function setShowDownStateOutside(param1:Boolean) : void
      {
         if(this._showDownStateOutside == param1)
         {
            return;
         }
         this._showDownStateOutside = param1;
         this.refreshState();
      }
      
      override protected function setMouseIsOver(param1:Boolean) : void
      {
         if(param1 == _mouseIsOver)
         {
            return;
         }
         super.setMouseIsOver(param1);
         this.refreshState();
      }
      
      override protected function setMouseIsDown(param1:Boolean) : void
      {
         if(param1 == _mouseIsDown)
         {
            return;
         }
         super.setMouseIsDown(param1);
         if(param1)
         {
            if(Boolean(this.repeatDelayId) || Boolean(this.repeatIntervalId))
            {
               return;
            }
            if(this.autoRepeat)
            {
               this.repeatDelayId = setTimeout(this.beginRepeating,this.repeatDelay);
            }
         }
         else
         {
            this.clearRepeating();
         }
         this.refreshState();
      }
      
      protected function beginRepeating() : void
      {
         if(Boolean(this.repeatIntervalId))
         {
            return;
         }
         clearTimeout(this.repeatDelayId);
         this.repeatDelayId = 0;
         if(this.autoRepeat)
         {
            this.repeatIntervalId = setInterval(this.repeatIntervalHandler,this.repeatInterval);
         }
      }
      
      protected function repeatIntervalHandler() : void
      {
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
      }
      
      protected function clearRepeating() : void
      {
         if(Boolean(this.repeatDelayId))
         {
            clearTimeout(this.repeatDelayId);
            this.repeatDelayId = 0;
         }
         if(Boolean(this.repeatIntervalId))
         {
            clearInterval(this.repeatIntervalId);
            this.repeatIntervalId = 0;
         }
      }
      
      protected function refreshState() : void
      {
         if(this.getEnabled())
         {
            if(this.getSelected())
            {
               if(Boolean(getMouseIsDown()) && (Boolean(getMouseIsOver()) || this.getShowDownStateOutside()))
               {
                  setCurrentState(ButtonStatesEnum.SELECTED_DOWN);
               }
               else if(getMouseIsOver())
               {
                  setCurrentState(ButtonStatesEnum.SELECTED_OVER);
               }
               else
               {
                  setCurrentState(ButtonStatesEnum.SELECTED_UP);
               }
            }
            else if(Boolean(getMouseIsDown()) && (Boolean(getMouseIsOver()) || this.getShowDownStateOutside()))
            {
               setCurrentState(ButtonStatesEnum.DOWN);
            }
            else if(getMouseIsOver())
            {
               setCurrentState(ButtonStatesEnum.OVER);
            }
            else
            {
               setCurrentState(ButtonStatesEnum.UP);
            }
         }
         else
         {
            setCurrentState(ButtonStatesEnum.DISABLED);
         }
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      public function setData(param1:*) : void
      {
         this._data = param1;
      }
      
      override public function destroy() : void
      {
         this._selectedChanged.removeAll();
         this._enabledChanged.removeAll();
         this.clearRepeating();
         super.destroy();
      }
   }
}

