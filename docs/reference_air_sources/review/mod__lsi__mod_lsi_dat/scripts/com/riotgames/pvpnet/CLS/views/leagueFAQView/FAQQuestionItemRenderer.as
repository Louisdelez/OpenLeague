package com.riotgames.pvpnet.CLS.views.leagueFAQView
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.rust.components.list.IListSelectable;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FAQQuestionItemRenderer extends SpriteProxy implements IDataRenderer, IListSelectable
   {
      
      private var _selectSignal:Signal = new Signal();
      
      private var _toggleSelectSignal:Signal = new Signal();
      
      private var _selectToSignal:Signal = new Signal();
      
      private var _data:*;
      
      private var _button:FAQQuestionButton;
      
      public function FAQQuestionItemRenderer(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._button = new FAQQuestionButton(this);
         this._button.addEventListener(MouseEvent.CLICK,this._onButtonClick);
         this.addChild(this._button);
      }
      
      protected function _onButtonClick(param1:MouseEvent) : void
      {
         this._selectSignal.dispatch(this);
      }
      
      public function setData(param1:*) : void
      {
         this._data = param1;
         this._button.setData(this._data);
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this._button.setSelected(param1);
      }
      
      public function get selectSignal() : ISignal
      {
         return this._selectSignal;
      }
      
      public function get toggleSelectSignal() : ISignal
      {
         return this._toggleSelectSignal;
      }
      
      public function get selectToSignal() : ISignal
      {
         return this._selectToSignal;
      }
   }
}

