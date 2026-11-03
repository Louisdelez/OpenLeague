package blix.util.file
{
   import flash.filesystem.File;
   
   public function directorySync(param1:File, param2:File, param3:Function, param4:Function, param5:Boolean = true, param6:Boolean = true, param7:Boolean = true) : void
   {
      DirectorySyncUtil.directorySyncInternal(param1,param2,param3,param4,new Vector.<File>(),new Vector.<File>(),new Vector.<File>(),param5,param6,param7);
   }
}

