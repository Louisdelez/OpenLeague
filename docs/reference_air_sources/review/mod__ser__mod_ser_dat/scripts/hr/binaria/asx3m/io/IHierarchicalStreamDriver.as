package hr.binaria.asx3m.io
{
   public interface IHierarchicalStreamDriver
   {
      
      function createWriter() : IHierarchicalStreamReader;
      
      function createReader() : IHierarchicalStreamReader;
   }
}

