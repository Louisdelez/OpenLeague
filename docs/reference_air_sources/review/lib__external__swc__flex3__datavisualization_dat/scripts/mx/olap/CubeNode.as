package mx.olap
{
   public dynamic class CubeNode
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _level:int;
      
      private var _numCells:int = 0;
      
      public function CubeNode(l:int = -1)
      {
         _level = l;
         super();
      }
      
      public function set numCells(value:int) : void
      {
         _numCells = value;
      }
      
      public function get numCells() : int
      {
         return _numCells;
      }
      
      public function get level() : int
      {
         return _level;
      }
   }
}

