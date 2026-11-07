package blix.components.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class ButtonModel
   {
      
      public var toggleOnClick:Boolean;
      
      protected var _enabledChanged:Signal = new Signal();
      
      protected var _selectedChanged:Signal = new Signal();
      
      protected var _enabled:Boolean = true;
      
      protected var _selected:Boolean;
      
      public function ButtonModel()
      {
         super();
      }
      
      public function getEnabledChanged() : ISignal
      {
         return this._enabledChanged;
      }
      
      public function getEnabled() : Boolean
      {
         return this._enabled;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(this._enabled == param1)
         {
            return;
         }
         this._enabled = param1;
         this._enabledChanged.dispatch(this,param1);
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
      }
   }
}

