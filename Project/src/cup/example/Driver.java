package cup.example;

import classes.TreeNode;
import classes.TreeNodePrinter;
import cup.table.SymbolsTable;

class Driver {

    public static void main(String[] args) throws Exception {
         Parser parser = new Parser();
         parser.parse();
         
         TreeNode root = parser.getParseTree();
         TreeNodePrinter treePrinter = new TreeNodePrinter(root);
         treePrinter.print();
         
         var symbolsTable = new SymbolsTable(root);
         symbolsTable.createTable();
         symbolsTable.printTable(); 
 		 //SymbolsTable table = new SymbolsTable();
        //table.createTable();
 		//table.printTable();
         
         //parser.debug_parse();
        /*
        ComplexSymbolFactory f = new ComplexSymbolFactory();
          
          File file = new File("input.txt");
          FileInputStream fis = null;
          try {
            fis = new FileInputStream(file);
          } catch (IOException e) {
            e.printStackTrace();
          } 
          Lexer lexer = new Lexer(f,fis);
          Symbol currentSymbol ;
          while ((currentSymbol = lexer.next_token()).sym != sym.EOF) {
              System.out.println("currentSymbol == " + currentSymbol);
          }*/
    }
    
}