package com.riotgames.pvpnet.CLS.views.rankingview.dropdownrenderers
{
   import blix.context.Context;
   import com.riotgames.pvpnet.CLS.views.enums.LeaguesDropdownTypesEnum;
   import com.riotgames.rust.components.list.renderer.DefaultListItem;
   
   public class LeagueDropdownRenderer extends DefaultListItem
   {
      
      private const SEPARATOR_LINKAGE:String = "SeparatorDropdownRenderer";
      
      private const CHALLENGER_SEPARATOR_LINKAGE:String = "ChallengerSeparatorRenderer";
      
      private var _dropDownItemRenderer:LeagueDropdownItemRenderer;
      
      private var _separator:LeagueDropDownSeparator;
      
      private var _challengerSeparator:LeagueDropDownSeparator;
      
      public function LeagueDropdownRenderer(param1:Context)
      {
         super(param1);
         setLinkage("holder");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._dropDownItemRenderer = new LeagueDropdownItemRenderer(this);
         this._separator = new LeagueDropDownSeparator(this,this.SEPARATOR_LINKAGE);
         this._challengerSeparator = new LeagueDropDownSeparator(this,this.CHALLENGER_SEPARATOR_LINKAGE);
      }
      
      override public function setData(param1:*) : void
      {
         if(param1 != null)
         {
            this.updateUI(param1);
         }
      }
      
      private function updateUI(param1:*) : void
      {
         this.removeAllChildren();
         this.getMouseIsOverChanged().add(this.onMouseOverChanged);
         setEnabled(true);
         if(param1.league)
         {
            this._dropDownItemRenderer.setData(param1);
            addChild(this._dropDownItemRenderer);
            this._dropDownItemRenderer.setSelected(param1.selected);
         }
         if(Boolean(param1.type) && (param1.type == LeaguesDropdownTypesEnum.SEPARATOR_TYPE || param1.type == LeaguesDropdownTypesEnum.CHALLENGER_SEPARATOR_TYPE))
         {
            switch(param1.type)
            {
               case LeaguesDropdownTypesEnum.SEPARATOR_TYPE:
                  this._separator.setData(param1);
                  addChild(this._separator);
                  break;
               case LeaguesDropdownTypesEnum.CHALLENGER_SEPARATOR_TYPE:
                  this._challengerSeparator.setData(param1);
                  addChild(this._challengerSeparator);
            }
            setEnabled(false);
         }
         else
         {
            this._dropDownItemRenderer.setData(param1);
            addChild(this._dropDownItemRenderer);
            this._dropDownItemRenderer.setSelected(param1.selected);
         }
      }
      
      private function onMouseOverChanged() : void
      {
         this._dropDownItemRenderer.toggleMouseOverState();
      }
   }
}

