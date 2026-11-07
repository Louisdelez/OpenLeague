package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.tooltip.SingleLineToolTip;
   import flash.display.Sprite;
   
   public class ListItemFriend extends SpriteProxy
   {
      
      private var _tooltipHandler:EmblemsToolTipHandler;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _tooltip:SingleLineToolTip;
      
      public function ListItemFriend(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         this._localeHelper = getDependency(ILocaleHelper);
         this._tooltip = new SingleLineToolTip(this);
         this._tooltipHandler = new EmblemsToolTipHandler(this._tooltip,1,0);
      }
      
      public function setFriend(param1:ListItemObjectModel) : void
      {
         setVisible(param1.isFriend);
         var _loc2_:EmblemModel = new EmblemModel(this._localeHelper.localeLookup("ttMeritFriend",[param1.summonerName]),"");
         assignToolTip(this,_loc2_,this._tooltipHandler);
      }
   }
}

