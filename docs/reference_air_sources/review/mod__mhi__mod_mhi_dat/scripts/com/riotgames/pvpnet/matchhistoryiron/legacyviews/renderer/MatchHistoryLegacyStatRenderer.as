package com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLinkage;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatRendererModel;
   
   public class MatchHistoryLegacyStatRenderer extends SpriteProxy implements IItemRenderer
   {
      
      private const THOUSAND_COMMA:int = 3;
      
      private const MILLION_COMMA:int = 6;
      
      private var _statText:TextFieldProxy;
      
      private var _statValueText:TextFieldProxy;
      
      private var _model:MatchHistoryStatRendererModel;
      
      private var _index:uint;
      
      public function MatchHistoryLegacyStatRenderer(param1:IContext)
      {
         super(param1);
         setLinkage(EMatchHistoryLinkage.STAT_RENDERER);
         setMouseEnabled(false);
         setMouseChildren(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._statText = new TextFieldProxy(this);
         this._statValueText = new TextFieldProxy(this);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_RENDERER_TEXT,this._statText);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_RENDERER_VALUE_TEXT,this._statValueText);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      public function setData(param1:*) : void
      {
         this._model = param1 as MatchHistoryStatRendererModel;
         var _loc2_:String = this.getNumberFormated(this._model.statValue);
         this._statText.setText(this._model.statName);
         this._statValueText.setText(_loc2_);
      }
      
      private function getNumberFormated(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:String = RiotResourceLoader.getString("thousands_seperator");
         var _loc4_:int = param1 / 1000000;
         var _loc5_:int = param1 / 1000 - _loc4_ * 1000;
         var _loc6_:int = param1 % 1000;
         if(_loc4_ > 0)
         {
            _loc2_ = _loc4_.toString() + _loc3_;
            _loc2_ += this.getFormatedThousand(_loc5_) + _loc3_;
            _loc2_ += this.getFormatedThousand(_loc6_);
         }
         else if(_loc5_ > 0)
         {
            _loc2_ += _loc5_ + _loc3_;
            _loc2_ += this.getFormatedThousand(_loc6_);
         }
         else
         {
            _loc2_ = _loc6_.toString();
         }
         return _loc2_;
      }
      
      private function getFormatedThousand(param1:int) : String
      {
         var _loc2_:String = "";
         if(param1 < 100)
         {
            _loc2_ += "0";
         }
         if(param1 < 10)
         {
            _loc2_ += "0";
         }
         return _loc2_ + param1.toString();
      }
   }
}

