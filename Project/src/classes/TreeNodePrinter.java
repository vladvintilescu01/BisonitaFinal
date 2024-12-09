// Vintilescu Vlad-Florian
// TreeNodePrinter.java
// 12.03.2024
package classes;

public class TreeNodePrinter {
    private TreeNode node = null;
    
    public TreeNodePrinter(TreeNode node) {
        this.node = node;
    }
    
    public void print() {
        printLevel(node, 0);
    }
    
    private void printLevel(TreeNode currentNode, int level) {
        if (currentNode == null) {
            return;
        }
        
        for (int i = 0; i < level; i++) {
            System.out.print("  ");
        }
        System.out.println(currentNode.getNodeInfo());
        
        TreeNode[] children = currentNode.getChildren();
        for (int i = 0; i < children.length; i++) {
            printLevel(children[i], level + 1);
        }
    }
}