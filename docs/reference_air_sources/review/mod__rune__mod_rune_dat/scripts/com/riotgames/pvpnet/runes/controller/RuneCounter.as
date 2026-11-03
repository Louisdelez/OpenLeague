package com.riotgames.pvpnet.runes.controller
{
   import blix.ds.IListX;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   
   public class RuneCounter
   {
      
      private var _runeBook:SpellBookDTO;
      
      private var _runesToCombine:IListX;
      
      private var _runeBookController:IRuneBookController;
      
      private var _runeBookPage:SpellBookPageDTO;
      
      private var _runeUniquePerSpellBook:Boolean;
      
      public function RuneCounter(param1:SpellBookDTO, param2:SpellBookPageDTO, param3:IRuneBookController, param4:IListX, param5:Boolean)
      {
         super();
         this._runeBook = param1;
         this._runeBookPage = param2;
         this._runeBookController = param3;
         this._runesToCombine = param4;
         this._runeUniquePerSpellBook = param5;
      }
      
      public function setRuneBook(param1:SpellBookDTO) : void
      {
         this._runeBook = param1;
      }
      
      public function setRuneBookPage(param1:SpellBookPageDTO) : void
      {
         this._runeBookPage = param1;
      }
      
      public function getUniqueRuneUsedCount(param1:Rune, param2:SpellBookDTO) : int
      {
         var _loc4_:SpellBookPageDTO = null;
         var _loc3_:int = 0;
         if(param2)
         {
            for each(_loc4_ in param2.bookPages)
            {
               _loc3_ += _loc4_.getSpecificRuneCount(param1);
            }
         }
         return _loc3_;
      }
      
      public function getCombineRuneUsedCount(param1:Rune, param2:IListX) : int
      {
         var _loc4_:Rune = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param2)
         {
            if(_loc4_.itemId == param1.itemId)
            {
               _loc3_++;
            }
         }
         return _loc3_;
      }
      
      public function getRuneUsedCountForPage(param1:Rune, param2:SpellBookPageDTO) : int
      {
         var _loc3_:int = 0;
         if(param2)
         {
            _loc3_ = int(param2.getSpecificRuneCount(param1));
         }
         return _loc3_;
      }
      
      public function getRuneUsedCount(param1:Rune) : int
      {
         var _loc2_:int = 0;
         if(this._runeUniquePerSpellBook || this._runeBookController.combining == true)
         {
            _loc2_ += this.getUniqueRuneUsedCount(param1,this._runeBook) + this.getCombineRuneUsedCount(param1,this._runesToCombine);
         }
         else
         {
            _loc2_ = this.getRuneUsedCountForPage(param1,this._runeBookPage);
         }
         return _loc2_;
      }
   }
}

