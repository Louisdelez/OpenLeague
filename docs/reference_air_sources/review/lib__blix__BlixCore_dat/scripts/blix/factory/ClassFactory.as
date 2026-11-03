package blix.factory
{
   public class ClassFactory
   {
      
      public var clazz:Class;
      
      public var args:Array;
      
      public function ClassFactory(param1:Class, param2:Array = null)
      {
         super();
         this.clazz = param1;
         this.args = param2 || [];
      }
      
      public function getInstance() : *
      {
         switch(this.args.length)
         {
            case 0:
               return new this.clazz();
            case 1:
               return new this.clazz(this.args[0]);
            case 2:
               return new this.clazz(this.args[0],this.args[1]);
            case 3:
               return new this.clazz(this.args[0],this.args[1],this.args[2]);
            case 4:
               return new this.clazz(this.args[0],this.args[1],this.args[2],this.args[3]);
            case 5:
               return new this.clazz(this.args[0],this.args[1],this.args[2],this.args[3],this.args[4]);
            case 6:
               return new this.clazz(this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5]);
            case 7:
               return new this.clazz(this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5],this.args[6]);
            case 8:
               return new this.clazz(this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5],this.args[6],this.args[7]);
            case 9:
               return new this.clazz(this.args[0],this.args[1],this.args[2],this.args[3],this.args[4],this.args[5],this.args[6],this.args[7],this.args[8]);
            default:
               return;
         }
      }
   }
}

