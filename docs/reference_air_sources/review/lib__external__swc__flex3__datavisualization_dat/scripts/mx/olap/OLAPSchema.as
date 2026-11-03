package mx.olap
{
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   [DefaultProperty("cubeArray")]
   public class OLAPSchema implements IOLAPSchema
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _cubes:Dictionary = new Dictionary();
      
      public function OLAPSchema()
      {
         super();
      }
      
      public function set cubeArray(value:Array) : void
      {
         var tempCubes:ArrayCollection = new ArrayCollection(value);
         cubes = tempCubes;
      }
      
      public function createCube(name:String) : IOLAPCube
      {
         var c:IOLAPCube = null;
         if(!_cubes[name])
         {
            c = new OLAPCube(name);
            _cubes[name] = c;
         }
         return _cubes[name];
      }
      
      public function getCube(name:String) : IOLAPCube
      {
         return _cubes[name];
      }
      
      public function addCube(cube:IOLAPCube) : Boolean
      {
         if(Boolean(_cubes[cube.name]))
         {
            return false;
         }
         _cubes[cube.name] = cube;
         return true;
      }
      
      public function set cubes(value:IList) : void
      {
         var cube:IOLAPCube = null;
         var cubeCount:int = int(value.length);
         for(var cIndex:int = 0; cIndex < cubeCount; cIndex++)
         {
            cube = value.getItemAt(cIndex) as IOLAPCube;
            _cubes[cube.name] = cube;
         }
      }
      
      public function get cubes() : IList
      {
         var i:Object = null;
         var temp:Array = [];
         for each(i in _cubes)
         {
            temp.push(i);
         }
         return new ArrayCollection(temp);
      }
   }
}

