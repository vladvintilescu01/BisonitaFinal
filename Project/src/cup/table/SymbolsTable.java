package cup.table;

import java.util.HashMap;
import java.util.Map;

import classes.TreeNode;
import cup.example.Parser;

public class SymbolsTable {
	
	 
	private TreeNode root = null;
	private HashMap<String, SymbolDetails> table = new HashMap<String, SymbolDetails>();

	public SymbolsTable(TreeNode rootElement)
	{
		root = rootElement;
	}
	private void extractSymbolsFromNode(TreeNode node, String currentContext, IdentifierScope scope) {
		String context = currentContext;
		IdentifierScope localScope = scope;
		if (node.getNodeInfo().equals("variable_declaration")) {
			var currentChildren = node.getChildren();
			if (currentChildren.length == 2)
			{
				var identifiersNode = currentChildren[1];
				var variableNames = identifiersNode.getChildren();
				
				for (int i = 0; i < variableNames.length; i++) {
				    String symbolName = variableNames[i].getNodeInfo();

				    if (table.containsKey(symbolName)) {
				        System.err.println("Error: Variable '" + symbolName + "' is declared multiple times in the same scope.");
				        System.exit(1);
				    } else {
				        SymbolDetails details = new SymbolDetails();
				        details.contextName = currentContext;
				        details.symbolName = symbolName;
				        details.dataType = currentChildren[0].getNodeInfo();
				        details.symbolScope = scope;
				        details.symbolType = SymbolType.Variable;
				        table.put(details.symbolName, details);
				    }
				}


			}
			
		}
		
		if (node.getNodeInfo().startsWith("function_declaration:")) {
	    	String afterColon = node.getNodeInfo().substring("function_declaration:".length());
	    	
	    	if (table.containsKey(afterColon)) {
		        System.err.println("Error: Function '" + afterColon + "' is defined multiple times in the same scope.");
		        System.exit(1);
		    }
	    	
	    	var currentChildren = node.getChildren();
		    SymbolDetails details = new SymbolDetails();
			details.contextName = currentContext;
			details.symbolName = afterColon;
			details.dataType = currentChildren[0].getNodeInfo();
			details.symbolScope = scope;
			details.symbolType = SymbolType.Function;
			table.put(details.symbolName, details);	
			if (currentChildren.length >= 2) {
				var paramsNode = currentChildren[1];
				var paramsNames = paramsNode.getChildren();
				
				for(int i = 0; i < paramsNames.length; i++)
				{					    
					String symbolName = paramsNames[i].getNodeInfo();
					
					if (table.containsKey("parameter " + symbolName + " from function " + afterColon)) {
						System.err.println("Error: Parameter '" + symbolName + "' is declared multiple times in the same scope, in function: " + afterColon);
						System.exit(1);
					} else {
						SymbolDetails details1 = new SymbolDetails();
						details1.contextName = afterColon;
						details1.symbolName = "parameter " + paramsNames[i].getNodeInfo() + " from function " + afterColon;
						details1.dataType = currentChildren[0].getNodeInfo();
						details1.symbolScope = IdentifierScope.Local;
						details1.symbolType = SymbolType.Variable;
						table.put(details1.symbolName, details1);	
					}
				}
			}
		   	context = afterColon;
		   	localScope = IdentifierScope.Local;
		}
		for (int i = 0; i < node.getChildren().length; i++) {
			extractSymbolsFromNode(node.getChildren()[i], context, localScope);
		}
	}

	public SymbolDetails getSymbol(String symbol)
	{
		if (table.containsKey(symbol))
		{
			return table.get(symbol);
		}
		return null;
	}
	public void createTable() {
		extractSymbolsFromNode(root, "Global", IdentifierScope.Global);
	}

	public void printTable() {
		for (Map.Entry<String, SymbolDetails> mapEntry : table.entrySet()) {
			String symbol = mapEntry.getKey();
			SymbolDetails details = mapEntry.getValue();
			System.out.println("-------------- SYMBOL: " + symbol + " --------------");
			System.out.println("Data Type: " + details.dataType);
			System.out.println("Context: " + details.contextName);
			System.out.println("Symbol Type: " + details.symbolType);
			System.out.println("Symbol scope: " + details.symbolScope);
		}
	}
}
