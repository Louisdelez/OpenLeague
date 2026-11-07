package hr.binaria.asx3m.io.xml
{
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   import system.data.List;
   import system.data.lists.ArrayList;
   import system.data.stacks.ArrayStack;
   
   public class E4XWriter implements IHierarchicalStreamWriter
   {
      
      private var _result:List;
      
      private var _nodeStack:ArrayStack;
      
      public function E4XWriter(param1:XML)
      {
         super();
         param1.setName("root_helper");
         _nodeStack = new ArrayStack();
         _result = new ArrayList();
         if(param1 != null)
         {
            _nodeStack.push(param1);
            _result.add(param1);
         }
      }
      
      public function flush() : void
      {
      }
      
      public function getCurrent() : XML
      {
         return _nodeStack.peek();
      }
      
      public function startNode(param1:String) : void
      {
         if(_nodeStack.size() == 1 && _nodeStack.peek() == <root_helper/>)
         {
            _nodeStack.peek().setName(param1);
         }
         else
         {
            _nodeStack.push(createNode(param1));
         }
      }
      
      public function endNode() : void
      {
         var _loc1_:XML = _nodeStack.pop();
         if(_nodeStack.size() == 0)
         {
            _result.add(_loc1_);
         }
      }
      
      public function setValue(param1:String) : void
      {
         top().appendChild(param1);
      }
      
      public function close() : void
      {
      }
      
      private function top() : XML
      {
         return getCurrent();
      }
      
      public function underlyingWriter() : IHierarchicalStreamWriter
      {
         return null;
      }
      
      public function getTopLevelNodes() : List
      {
         return _result;
      }
      
      public function addAttribute(param1:String, param2:String) : void
      {
         top()[param1] = param2;
      }
      
      public function createNode(param1:String) : XML
      {
         var _loc2_:XML = <new/>;
         _loc2_.setName(param1);
         if(top() != null)
         {
            top().appendChild(_loc2_);
         }
         return _loc2_;
      }
   }
}

