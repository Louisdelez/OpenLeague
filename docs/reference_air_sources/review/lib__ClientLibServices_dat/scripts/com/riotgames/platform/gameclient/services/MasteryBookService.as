package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.MasteryBookDTO;
   import com.riotgames.platform.gameclient.domain.MasteryBookPageDTO;
   
   public interface MasteryBookService
   {
      
      function selectDefaultMasteryBookPage(param1:MasteryBookPageDTO, param2:Function, param3:Function, param4:Function) : void;
      
      function getMasteryBook(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function saveMasteryBook(param1:MasteryBookDTO, param2:Function, param3:Function, param4:Function) : void;
   }
}

