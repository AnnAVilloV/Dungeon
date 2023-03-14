final class BSPmap{
  
  void generate(BSPnode current){
    if(current.isDividable()){
      current.divide();
      
      int nextDepth = current.depth + 1;
      if(!nodes.containsKey(nextDepth)){
        nodes.put(nextDepth, new ArrayList<BSPnode>());
      }
      nodes.get(nextDepth).add(current.leftChild);
      nodes.get(nextDepth).add(current.rightChild);
      
      generate(current.leftChild);
      generate(current.rightChild);
    }
    return;
  }

}
