package com.riotgames.pvpnet.system.alerter
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class AlertWithCheckBoxAction extends AlertAction
   {
      
      public var affirmative_requires_checkbox_selection:Boolean;
      
      public var checkbox_above_buttons:Boolean;
      
      private var _checkbox_selected:Boolean;
      
      private var _checkbox_selected_changed:Signal = new Signal();
      
      private var _checkbox_text:String;
      
      private var _checkbox_text_changed:Signal = new Signal();
      
      public function AlertWithCheckBoxAction(param1:String, param2:String, param3:Boolean, param4:String)
      {
         super(param1,param2);
         this.checkbox_selected = param3;
         this.checkbox_text = param4;
      }
      
      public function get checkbox_selected() : Boolean
      {
         return this._checkbox_selected;
      }
      
      public function set checkbox_selected(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._checkbox_selected;
         if(_loc2_ != param1)
         {
            this._checkbox_selected = param1;
            this._checkbox_selected_changed.dispatch(this._checkbox_selected_changed,_loc2_,param1);
         }
      }
      
      public function get checkbox_selected_changed() : ISignal
      {
         return this._checkbox_selected_changed;
      }
      
      public function get checkbox_text() : String
      {
         return this._checkbox_text;
      }
      
      public function set checkbox_text(param1:String) : void
      {
         var _loc2_:String = this._checkbox_text;
         if(_loc2_ != param1)
         {
            this._checkbox_text = param1;
            this._checkbox_text_changed.dispatch(this._checkbox_text_changed,_loc2_,param1);
         }
      }
      
      public function get checkbox_text_changed() : ISignal
      {
         return this._checkbox_text_changed;
      }
   }
}

