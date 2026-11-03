package com.riotgames.platform.module.masteries.views.renderers
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.masteries.Talent;
   import com.riotgames.platform.gameclient.masteries.TalentGroup;
   import com.riotgames.platform.gameclient.masteries.TalentRow;
   import com.riotgames.platform.masteries.events.MasteryEvent;
   import com.riotgames.platform.masteries.utilities.MasteriesUtils;
   import com.riotgames.platform.module.masteries.views.renderers.tooltips.MasteryItemToolTipModel;
   import flash.events.MouseEvent;
   
   public class MasteryItemRendererProxy extends StatefulView
   {
      
      private var _talentReference:Talent;
      
      private var _rank:int = 0;
      
      private var _activated:Boolean = true;
      
      public var masteryLinkReference:MasteryLinkRendererProxy;
      
      private var _requirementsDesciption:String;
      
      private var tooltipModel:MasteryItemToolTipModel;
      
      private var _masteryIcon:SpriteProxy;
      
      private var _rankDisplay:TextFieldProxy;
      
      public function MasteryItemRendererProxy(param1:IContext)
      {
         super(param1);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseClick);
         addEventListener(MouseEvent.CONTEXT_MENU,this.onMouseClick);
         this.createTooltip();
         setLinkage("MasteryRenderer");
      }
      
      override public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseClick);
         removeEventListener(MouseEvent.CONTEXT_MENU,this.onMouseClick);
         unassignToolTip(this);
         super.destroy();
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.target is MasteryItemRendererProxy)
         {
            if(param1.type == "mouseWheel")
            {
               _loc2_ = param1.delta;
            }
            else if(param1.type == MouseEvent.CONTEXT_MENU)
            {
               _loc2_ = -1;
            }
            else
            {
               _loc2_ = 1;
            }
         }
         dispatchEvent(new MasteryEvent(MasteryEvent.MASTERY_CLICK,true,false,this._talentReference.tltId,_loc2_));
      }
      
      private function setProperlyActivatedState() : void
      {
         if(this._rank == this.talentReference.maxRank)
         {
            this.setCurrentState("maxed");
         }
         else
         {
            this.setCurrentState("active");
         }
         if(this.masteryLinkReference != null)
         {
            this.masteryLinkReference.setCurrentState(this.getCurrentState());
         }
      }
      
      public function get activated() : Boolean
      {
         return this._activated;
      }
      
      public function set rank(param1:int) : void
      {
         if(this._rank == param1)
         {
            return;
         }
         this._rank = param1;
         this.updateRankDisplay();
         this.setProperlyActivatedState();
         this.updateTooltip();
      }
      
      private function createTooltip() : void
      {
         if(this.tooltipModel == null)
         {
            this.tooltipModel = new MasteryItemToolTipModel("",0,"","","","inactive");
         }
         assignToolTip(this,this.tooltipModel,null);
      }
      
      public function set activated(param1:Boolean) : void
      {
         if(this._rank > 0)
         {
            if(this._activated != true)
            {
               this._activated = true;
               this.setProperlyActivatedState();
            }
         }
         else
         {
            this._activated = param1;
            if(this._activated || this._rank > 0)
            {
               this.setProperlyActivatedState();
            }
            else
            {
               this.setInactive();
            }
         }
         this.updateTooltip();
      }
      
      override protected function createChildren() : void
      {
         this._masteryIcon = new SpriteProxy(this);
         this._rankDisplay = new TextFieldProxy(this);
         this.setTimelineChildByName("masteryIcon",this._masteryIcon);
         this.setTimelineChildByName("rankDisplay",this._rankDisplay);
      }
      
      public function get rank() : int
      {
         return this._rank;
      }
      
      private function updateRankDisplay() : void
      {
         this._rankDisplay.setText(this._rank + "/" + this._talentReference.maxRank);
      }
      
      public function get masteryID() : int
      {
         return this._talentReference.tltId;
      }
      
      private function updateTooltip() : void
      {
         if(this._talentReference == null)
         {
            return;
         }
         var _loc1_:String = RiotResourceLoader.getTalentResourceString("name",this._talentReference.tltId,-1);
         var _loc2_:String = RiotResourceLoader.getString("masteries_tooltip_rank","RANK") + " " + this._rank + "/" + this._talentReference.maxRank;
         this.createRequirementsMessage();
         var _loc3_:int = this._rank;
         if(_loc3_ == 0)
         {
            _loc3_ = 1;
         }
         var _loc4_:String = RiotResourceLoader.getTalentResourceString("desc",this._talentReference.tltId,_loc3_);
         if(this._rank > 0 && this._rank < this._talentReference.maxRank)
         {
            if(_loc4_ != null && _loc4_.length > 0)
            {
               _loc4_ += "\n\n";
            }
            _loc4_ += RiotResourceLoader.getString("masteries_tooltip_nextRank","Next RANK") + "\n" + RiotResourceLoader.getTalentResourceString("desc",this._talentReference.tltId,_loc3_ + 1);
         }
         this.tooltipModel.updateModelInfo(_loc1_,this._talentReference.talentGroupId,_loc2_,this._requirementsDesciption,_loc4_,this.getCurrentState());
      }
      
      private function createRequirementsMessage() : void
      {
         var _loc6_:String = null;
         var _loc1_:Array = [];
         var _loc2_:TalentRow = MasteriesUtils.getMasteryRowByMasteryID(this._talentReference.tltId);
         var _loc3_:TalentGroup = MasteriesUtils.getMasteryGroupByMasteryID(this._talentReference.tltId);
         var _loc4_:Talent = MasteriesUtils.getMasteryByID(this._talentReference.prereqTalentGameCode);
         var _loc5_:String = RiotResourceLoader.getString("masteries_tooltip_name_" + _loc3_.name,_loc3_.name);
         if(_loc2_.pointsToActivate > 0)
         {
            _loc1_.push(RiotResourceLoader.getString("talentTree_requirements_pointsToActivate","Need more to activate",[_loc2_.pointsToActivate,_loc5_]));
         }
         if(Boolean(_loc4_) && _loc4_.tltId != this._talentReference.tltId)
         {
            _loc6_ = RiotResourceLoader.getTalentResourceString("name",_loc4_.gameCode,-1);
            _loc1_.push(RiotResourceLoader.getString("talentTree_requirements_pointsToActivate","Need another mastery first.",[_loc4_.maxRank,_loc6_]));
         }
         if(_loc1_.length > 0)
         {
            this._requirementsDesciption = _loc1_.join("\n") as String;
         }
         else
         {
            this._requirementsDesciption = "";
         }
      }
      
      private function setInactive() : void
      {
         this.setCurrentState("inactive");
         if(this.masteryLinkReference != null)
         {
            this.masteryLinkReference.setCurrentState(this.getCurrentState());
         }
      }
      
      public function set talentReference(param1:Talent) : void
      {
         if(this._talentReference === param1)
         {
            return;
         }
         this._talentReference = param1;
         var _loc2_:DisplayObjectProxy = new DisplayObjectProxy(this,ImagePackLookup.instance.getMasteryBitmap(this._talentReference));
         _loc2_.setWidth(50);
         _loc2_.setHeight(50);
         this._masteryIcon.addChild(_loc2_);
         this.updateRankDisplay();
         this.updateTooltip();
      }
      
      public function get talentReference() : Talent
      {
         return this._talentReference;
      }
   }
}

