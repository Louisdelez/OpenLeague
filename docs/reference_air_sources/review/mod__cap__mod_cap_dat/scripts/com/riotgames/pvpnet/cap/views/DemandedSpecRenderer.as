package com.riotgames.pvpnet.cap.views
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapDemandedSpec;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class DemandedSpecRenderer extends ButtonX implements ISelectableRenderer
   {
      
      private var _index:uint;
      
      private var _specSelected:Signal = new Signal();
      
      private var _capModel:CapModel;
      
      private var _viewMediator:CapViewMediator;
      
      private var _positionText:TextFieldProxy;
      
      private var _positionIcon:StatefulView;
      
      private var _roleText:TextFieldProxy;
      
      private var _rankIcon:StatefulView;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _roleIcon:StatefulView;
      
      private var _specModel:CapDemandedSpec;
      
      private var _soundProvider:ISoundProvider;
      
      public function DemandedSpecRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("DemandedSpecRenderer");
      }
      
      private function updateView() : void
      {
         if(this._specModel)
         {
            this._roleIcon.setCurrentState(this._specModel.role.id);
            this._roleText.setText(this._specModel.role.name);
            this._positionIcon.setCurrentState(this._specModel.position.id);
            this._positionText.setText(this._specModel.position.name);
            this._rankIcon.setCurrentState(String(Math.min(this._index,2)));
         }
      }
      
      private function setSpecModel(param1:CapDemandedSpec) : void
      {
         this._specModel = param1;
         this.updateView();
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
         this.updateView();
      }
      
      override protected function initializeDependencies() : void
      {
         this._viewMediator = getDependency(CapViewMediator);
         this._capModel = getDependency(CapModel);
         this._soundProvider = getDependency(ISoundProvider);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._roleIcon = new StatefulView(this);
         setTimelineChildByName("role",this._roleIcon);
         this._roleText = new TextFieldProxy(this);
         setTimelineChildByName("roleText",this._roleText);
         this._roleText.setText("");
         this._positionIcon = new StatefulView(this);
         setTimelineChildByName("position",this._positionIcon);
         this._positionText = new TextFieldProxy(this);
         setTimelineChildByName("positionText",this._positionText);
         this._positionText.setText("");
         this._rankIcon = new StatefulView(this);
         setTimelineChildByName("rank",this._rankIcon);
         addEventListener(MouseEvent.CLICK,this.handleClicked);
         super.createChildren();
      }
      
      private function handleClicked(param1:MouseEvent) : void
      {
         this._viewMediator.currentState.handlePositionSelected(this._specModel.position,this._capModel.localPlayerSelection);
         this._viewMediator.currentState.handleRoleSelected(this._specModel.role,this._capModel.localPlayerSelection);
         this._specSelected.dispatch(this._specModel);
         this._soundProvider.play(CapAudioKeys.CAP_DROP_DOWN_SELECT);
      }
      
      override public function getData() : *
      {
         return this._specModel;
      }
      
      override public function setData(param1:*) : void
      {
         this.setSpecModel(param1);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      override public function destroy() : void
      {
         this._specSelected.removeAll();
         super.destroy();
      }
      
      public function getSpecSelected() : ISignal
      {
         return this._specSelected;
      }
   }
}

