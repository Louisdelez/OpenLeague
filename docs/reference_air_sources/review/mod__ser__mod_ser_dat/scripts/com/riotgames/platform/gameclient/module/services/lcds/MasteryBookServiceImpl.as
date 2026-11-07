package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.domain.MasteryBookDTO;
   import com.riotgames.platform.gameclient.domain.MasteryBookPageDTO;
   import com.riotgames.platform.gameclient.services.MasteryBookService;
   
   public class MasteryBookServiceImpl extends BaseLcdsService implements MasteryBookService
   {
      
      public function MasteryBookServiceImpl()
      {
         super();
      }
      
      public function getMasteryBook(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("masteryBookService","getMasteryBook",[param1],param2,param3);
      }
      
      public function selectDefaultMasteryBookPage(param1:MasteryBookPageDTO, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("masteryBookService","selectDefaultMasteryBookPage",[param1],param2,param3);
      }
      
      public function saveMasteryBook(param1:MasteryBookDTO, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("masteryBookService","saveMasteryBook",[param1],param2,param3);
      }
   }
}

