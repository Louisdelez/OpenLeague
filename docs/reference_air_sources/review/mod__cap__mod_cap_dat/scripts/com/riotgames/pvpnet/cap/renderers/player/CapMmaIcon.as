package com.riotgames.pvpnet.cap.renderers.player
{
   import blix.components.timeline.StatefulView;
   import blix.components.timeline.TimelineAnimation;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.views.tooltips.CapMmaDescriptionTooltip;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.RectPosition;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class CapMmaIcon extends StatefulView
   {
      
      private static const ACTIVE_ANIMATION:String = "yes";
      
      private static const INACTIVE_ANIMATION:String = "no";
      
      private static const THINKING_ANIMATION:String = "thinking";
      
      private static const INTRO_ANIMATION:String = "intro";
      
      private static const IDLE_ANIMATION:String = "idle";
      
      private static const invisibleStates:Array = [CapPlayerSelection.INTRO_STATE,CapPlayerSelection.CHAMP_SELECTED_STATE];
      
      private static const _tooltipConfig:ToolTipConfig = new ToolTipConfig();
      
      private const TOOLTIP_OFFSET_X:int = 2;
      
      private const TOOLTIP_OFFSET_Y:int = 0;
      
      private var _model:CapModel = null;
      
      private var _playerSelection:CapPlayerSelection = null;
      
      private var _content:StatefulView;
      
      private var _isProcessing:Boolean = false;
      
      public function CapMmaIcon(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setMouseChildren(false);
         this.playerSelection = this._model.localPlayerSelection;
         _tooltipConfig.showDelay = 0;
         _tooltipConfig.toolTipPosition = new RectPosition(RectPosition.LEFT_MIDDLE,RectPosition.RIGHT_MIDDLE);
         _tooltipConfig.gap = new Point(this.TOOLTIP_OFFSET_X,this.TOOLTIP_OFFSET_Y);
         _tooltipConfig.cacheView = false;
      }
      
      private function updateVisiblity() : void
      {
         var _loc1_:Boolean = this._playerSelection.mmaBonus.bonusAllowed && invisibleStates.indexOf(this._playerSelection.currentState) == -1;
         setVisible(_loc1_);
      }
      
      override protected function createChildren() : void
      {
         setVisible(false);
         this._content = new StatefulView(this);
         setTimelineChildByName("content",this._content);
         super.createChildren();
      }
      
      private function changeStateWithThinkingTransition(param1:String) : void
      {
         var processingAnimation:TimelineAnimation;
         var targetState:String = param1;
         this._isProcessing = true;
         setCurrentState(THINKING_ANIMATION);
         processingAnimation = getStateAnimation(THINKING_ANIMATION);
         processingAnimation.setRepeatCount(1);
         processingAnimation.invoke();
         processingAnimation.getCompleted().addOnce(function():void
         {
            onThinkingComplete(targetState);
         });
      }
      
      override public function destroy() : void
      {
         if(this._playerSelection != null && this._playerSelection.mmaBonus != null)
         {
            this._playerSelection.mmaBonus.championBonusActiveChanged.remove(this.updateState);
            this._playerSelection.mmaBonus.roleBonusActiveChanged.remove(this.updateState);
            this._playerSelection.mmaBonus.positionBonusActiveChanged.remove(this.updateState);
         }
         unassignToolTip(this);
         super.destroy();
      }
      
      private function updateState() : void
      {
         unassignToolTip(this);
         this.updateVisiblity();
         var _loc1_:String = this._playerSelection.mmaBonus.hasBonus() ? ACTIVE_ANIMATION : INACTIVE_ANIMATION;
         this.changeStateWithThinkingTransition(_loc1_);
      }
      
      private function set playerSelection(param1:CapPlayerSelection) : void
      {
         if(this._playerSelection != null && this._playerSelection.mmaBonus != null)
         {
            this._playerSelection.currentStateChanged.remove(this.updateState);
            this._playerSelection.mmaBonus.bonusAllowedChanged.remove(this.updateState);
            this._playerSelection.mmaBonus.championBonusActiveChanged.remove(this.updateState);
            this._playerSelection.mmaBonus.roleBonusActiveChanged.remove(this.updateState);
            this._playerSelection.mmaBonus.positionBonusActiveChanged.remove(this.updateState);
         }
         this._playerSelection = param1;
         if(this._playerSelection != null && this._playerSelection.mmaBonus != null)
         {
            this._playerSelection.currentStateChanged.add(this.updateState);
            this._playerSelection.mmaBonus.bonusAllowedChanged.add(this.updateState);
            this._playerSelection.mmaBonus.championBonusActiveChanged.add(this.updateState);
            this._playerSelection.mmaBonus.roleBonusActiveChanged.add(this.updateState);
            this._playerSelection.mmaBonus.positionBonusActiveChanged.add(this.updateState);
            this.updateState();
         }
      }
      
      private function onThinkingComplete(param1:String) : void
      {
         var targetAnimation:TimelineAnimation;
         var targetState:String = param1;
         setCurrentState(targetState);
         this._isProcessing = false;
         this._content.setCurrentState(INTRO_ANIMATION);
         targetAnimation = this._content.getStateAnimation(INTRO_ANIMATION);
         targetAnimation.setRepeatCount(1);
         targetAnimation.invoke();
         targetAnimation.getCompleted().addOnce(function():void
         {
            _content.setCurrentState(IDLE_ANIMATION);
         });
         TipsProviderProxy.instance.assignCustomToolTip(this,this._model.localPlayerSelection.mmaBonus,CapMmaDescriptionTooltip,_tooltipConfig);
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(CapModel);
         super.initializeDependencies();
      }
   }
}

