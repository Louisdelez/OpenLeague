package com.riotgames.pvpnet.cap.renderers.player
{
   import blix.IDestructible;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.rust.decorator.AnimationToggleDecorator;
   
   public class CapPlayerRendererBase extends StatefulView implements IItemRenderer, IDestructible
   {
      
      private static const SHOW_DEBUG_TOOLTIPS:Boolean = false;
      
      protected var _data:*;
      
      protected var rendererIndex:uint;
      
      protected var _viewMediator:CapViewMediator;
      
      private var defaultTooltipHandler:ToolTipHandler;
      
      protected var _model:CapModel;
      
      protected var playerSelection:CapPlayerSelection;
      
      public function CapPlayerRendererBase(param1:IContext)
      {
         super(param1);
         var _loc2_:AnimationToggleDecorator = getDependency(AnimationToggleDecorator);
         _loc2_.apply(this);
      }
      
      protected function handleRoleSelected(param1:CapRole) : void
      {
         this._viewMediator.currentState.handleRoleSelected(param1,this.playerSelection);
      }
      
      protected function handlePositionSelected(param1:CapPosition) : void
      {
         this._viewMediator.currentState.handlePositionSelected(param1,this.playerSelection);
      }
      
      protected function updateState() : void
      {
      }
      
      protected function subscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         param1.isInvitedPlayerChanged.add(this.updateTooltips);
         param1.currentStateChanged.add(this.updateTooltips);
         param1.roleChanged.add(this.updateTooltips);
         param1.advertisedRoleChanged.add(this.updateTooltips);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.model = getDependency(CapModel);
         this._viewMediator = getDependency(CapViewMediator);
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      protected function set model(param1:CapModel) : void
      {
         this._model = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      public function getIndex() : uint
      {
         return this.rendererIndex;
      }
      
      public function setData(param1:*) : void
      {
         if(this.playerSelection)
         {
            this.unsubscribeToDataChanges(this.playerSelection);
         }
         this._data = param1;
         this.playerSelection = param1 as CapPlayerSelection;
         if(this.playerSelection)
         {
            this.subscribeToDataChanges(this.playerSelection);
         }
         this.updateState();
         this.updateChildren();
         invalidateLayout();
      }
      
      protected function unsubscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         param1.isInvitedPlayerChanged.remove(this.updateTooltips);
         param1.currentStateChanged.remove(this.updateTooltips);
         param1.roleChanged.remove(this.updateTooltips);
         param1.advertisedRoleChanged.remove(this.updateTooltips);
      }
      
      protected function updateChildren() : void
      {
         this.updateTooltips();
      }
      
      public function setIndex(param1:uint) : void
      {
         this.rendererIndex = param1;
      }
      
      private function updateTooltips() : void
      {
         if(!SHOW_DEBUG_TOOLTIPS)
         {
            return;
         }
         if(!this.playerSelection)
         {
            return;
         }
         var _loc1_:String = "Role = " + (this.playerSelection.role ? this.playerSelection.role.name : "null") + "\nAdvertised Role = " + (this.playerSelection.advertisedRole ? this.playerSelection.advertisedRole.name : "null");
         assignToolTip(this,_loc1_);
      }
      
      override public function destroy() : void
      {
         var _loc1_:AnimationToggleDecorator = getDependency(AnimationToggleDecorator);
         _loc1_.unapply(this);
         super.destroy();
      }
   }
}

