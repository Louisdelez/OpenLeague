package mx.messaging.channels.amfx
{
   import mx.logging.ILogger;
   
   [ExcludeClass]
   public class AMFXContext
   {
      
      internal var traits:Array;
      
      internal var objects:Array;
      
      internal var strings:Array;
      
      public var log:ILogger;
      
      public function AMFXContext()
      {
         super();
         this.reset();
      }
      
      public function reset() : void
      {
         this.traits = [];
         this.objects = [];
         this.strings = [];
      }
      
      public function findTraitInfo(traitInfo:Object) : int
      {
         var ti:Object = null;
         var j:uint = 0;
         for(var i:uint = 0; i < this.traits.length; i++)
         {
            ti = this.traits[i];
            if(ti.alias == traitInfo.alias && ti.properties.length == traitInfo.properties.length)
            {
               for(j = 0; j < ti.properties.length; )
               {
                  if(ti.properties[i] != traitInfo.properties[j])
                  {
                     break;
                  }
                  j++;
               }
               if(j == traitInfo.properties.length)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      public function findObject(object:Object) : int
      {
         var o:Object = null;
         for(var i:uint = 0; i < this.objects.length; i++)
         {
            o = this.objects[i];
            if(o === object)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function findString(str:String) : int
      {
         var i:uint = 0;
         var s:String = null;
         if(str != "")
         {
            for(i = 0; i < this.strings.length; i++)
            {
               s = this.strings[i];
               if(s == str)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      public function addTraitInfo(traitInfo:Object) : void
      {
         this.traits.push(traitInfo);
      }
      
      public function addObject(obj:Object) : void
      {
         this.objects.push(obj);
      }
      
      public function addString(str:String) : void
      {
         if(str != "")
         {
            this.strings.push(str);
         }
      }
      
      public function getTraitInfo(ref:uint) : *
      {
         return this.traits[ref];
      }
      
      public function getObject(ref:uint) : *
      {
         return this.objects[ref];
      }
      
      public function getString(ref:uint) : String
      {
         return this.strings[ref];
      }
   }
}

