package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class MatchHistoryParticipantSelectionRenderer extends ButtonX implements IItemRenderer, ISelectableRenderer
   {
      
      private var _index:uint;
      
      private var _participant:MatchHistoryGameParticipant;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _championIcon:NewMatchHistoryChampionRenderer;
      
      private var _championIconSizer:SpriteProxy;
      
      private var _background:StatefulView;
      
      public function MatchHistoryParticipantSelectionRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("ParticipantSelectionRenderer");
      }
      
      override protected function createChildren() : void
      {
         this._championIcon = new NewMatchHistoryChampionRenderer(this);
         setTimelineChildByName("container",this._championIcon);
         this._championIconSizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._championIconSizer);
         this._background = new StatefulView(this);
         setTimelineChildByName("background",this._background);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         super.createChildren();
      }
      
      private function updateView() : void
      {
         if(this._participant)
         {
            this._championIcon.setChampion(this._participant.champion);
            this._background.setCurrentState(this._participant.teamId + (_selected ? "_selected" : "_unselected"));
         }
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._championIcon.setExplicitSize(this._championIconSizer.getWidth(),this._championIconSizer.getHeight());
         this._championIcon.setExplicitPosition(this._championIconSizer.getX(),this._championIconSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      override public function setSelected(param1:Boolean) : void
      {
         if(_selected == param1)
         {
            return;
         }
         _selected = param1;
         this.updateView();
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override public function getData() : *
      {
         return this._participant;
      }
      
      override public function setData(param1:*) : void
      {
         this._participant = param1;
         this.updateView();
      }
   }
}

