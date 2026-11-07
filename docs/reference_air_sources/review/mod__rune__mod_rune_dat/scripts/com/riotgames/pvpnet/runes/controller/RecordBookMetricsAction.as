package com.riotgames.pvpnet.runes.controller
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import mx.collections.ArrayCollection;
   
   public class RecordBookMetricsAction extends BasicAction
   {
      
      private var _runesTracker:IRunesTracker;
      
      private var _runeBook:SpellBookDTO;
      
      private var _summonerRunes:ArrayCollection;
      
      public function RecordBookMetricsAction(param1:IRunesTracker, param2:SpellBookDTO = null, param3:ArrayCollection = null)
      {
         super(false);
         this._runesTracker = param1;
         this.setTrackRequirements(this._runeBook,this._summonerRunes);
      }
      
      public function setTrackRequirements(param1:SpellBookDTO, param2:ArrayCollection) : void
      {
         this._runeBook = param1;
         this._summonerRunes = param2;
      }
      
      override protected function doInvocation() : void
      {
         this.recordBookMetrics();
         complete();
      }
      
      private function recordBookMetrics() : void
      {
         var _loc5_:SpellBookPageDTO = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:SummonerRune = null;
         var _loc17_:Rune = null;
         if(!this._runeBook || !this._summonerRunes)
         {
            return;
         }
         var _loc1_:Number = Number(this._runeBook.bookPages.length);
         this._runesTracker.setRunes_TotalPages_Count(_loc1_);
         var _loc2_:Array = [];
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         for each(_loc5_ in this._runeBook.bookPages)
         {
            _loc4_ += this.checkBookPageForMixedRunes(_loc5_) ? 1 : 0;
            if(_loc5_.getCombinedStats().length != 0)
            {
               _loc3_ += 1;
            }
            _loc2_.push(_loc5_.displayName);
         }
         this._runesTracker.setRunes_PagesWithMixedRunes_Count(_loc4_);
         this._runesTracker.setRunes_PagesWithRunes_Count(_loc3_);
         this._runesTracker.setRunes_PageNames(_loc2_);
         _loc6_ = _loc3_ / _loc1_;
         _loc7_ = _loc4_ / _loc1_;
         this._runesTracker.setRunes_PagesWithRunes_Percentage(_loc6_);
         this._runesTracker.setRunes_PagesWithMixedRunes_Percentage(_loc7_);
         _loc8_ = 0;
         _loc9_ = 0;
         _loc10_ = 0;
         _loc11_ = 0;
         _loc12_ = 0;
         _loc13_ = 0;
         _loc14_ = 0;
         _loc15_ = 0;
         for each(_loc16_ in this._summonerRunes)
         {
            _loc15_ += _loc16_.quantity;
            _loc17_ = _loc16_.rune;
            switch(_loc17_.runeType.runeTypeId)
            {
               case RuneType.RED_RUNE:
                  _loc8_ += _loc16_.quantity;
                  break;
               case RuneType.BLACK_RUNE:
                  _loc11_ += _loc16_.quantity;
                  break;
               case RuneType.BLUE_RUNE:
                  _loc10_ += _loc16_.quantity;
                  break;
               case RuneType.YELLOW_RUNE:
                  _loc9_ += _loc16_.quantity;
            }
            switch(_loc17_.tier)
            {
               case 1:
                  _loc12_ += _loc16_.quantity;
                  break;
               case 2:
                  _loc13_ += _loc16_.quantity;
                  break;
               case 3:
                  _loc14_ += _loc16_.quantity;
            }
         }
         this._runesTracker.setRunes_TotalOwnedMarks_Count(_loc8_);
         this._runesTracker.setRunes_TotalOwnedSeals_Count(_loc9_);
         this._runesTracker.setRunes_TotalOwnedGlyphs_Count(_loc10_);
         this._runesTracker.setRunes_TotalOwnedQuints_Count(_loc11_);
         this._runesTracker.setRunes_TotalOwnedTier1_Count(_loc12_);
         this._runesTracker.setRunes_TotalOwnedTier2_Count(_loc13_);
         this._runesTracker.setRunes_TotalOwnedTier3_Count(_loc14_);
         this._runesTracker.setRunes_TotalOwnedRunes_Count(_loc15_);
      }
      
      private function getFirstFilledRune(param1:SpellBookPageDTO, param2:int, param3:int) : Rune
      {
         var _loc4_:Rune = null;
         var _loc5_:int = param2;
         while(_loc5_ <= param3)
         {
            _loc4_ = param1.getRuneBySlotNumber(_loc5_);
            if(_loc4_ != null)
            {
               break;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function checkBookPageForMixedRunes(param1:SpellBookPageDTO) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Rune = null;
         var _loc4_:Rune = this.getFirstFilledRune(param1,1,9);
         var _loc5_:Boolean = false;
         _loc2_ = 2;
         while(_loc2_ < 10)
         {
            _loc3_ = param1.getRuneBySlotNumber(_loc2_);
            if(Boolean(_loc3_) && _loc3_.itemId != _loc4_.itemId)
            {
               _loc5_ = true;
               break;
            }
            _loc2_++;
         }
         var _loc6_:Rune = this.getFirstFilledRune(param1,10,18);
         var _loc7_:Boolean = false;
         _loc2_ = 11;
         while(_loc2_ < 19)
         {
            _loc3_ = param1.getRuneBySlotNumber(_loc2_);
            if(Boolean(_loc3_) && _loc3_.itemId != _loc6_.itemId)
            {
               _loc7_ = true;
               break;
            }
            _loc2_++;
         }
         var _loc8_:Rune = this.getFirstFilledRune(param1,19,27);
         var _loc9_:Boolean = false;
         _loc2_ = 20;
         while(_loc2_ < 28)
         {
            _loc3_ = param1.getRuneBySlotNumber(_loc2_);
            if(Boolean(_loc3_) && _loc3_.itemId != _loc8_.itemId)
            {
               _loc9_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc5_ || _loc7_ || _loc9_;
      }
   }
}

