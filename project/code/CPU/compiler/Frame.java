package complier;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.LineBorder;

public class Frame extends JFrame implements ActionListener
{
	JButton add = new JButton("选择文件");					//添加文件按钮
	JButton start = new JButton("开始编译");				//添加编译按钮
	JTextField showFileName = new JTextField(40);		//显示文件路径
	String fileName;									//选择的文件名
	
	public String getFileName()							//返回得到的文件名
	{
		return fileName;
	}
	
	public Frame()										//创建编译器主界面
	{
		JFrame frame = new JFrame("编译器");
		ImageIcon image = new ImageIcon("sea.jpg");					//背景图片
		frame.setSize(image.getIconWidth(),image.getIconHeight());				//设置大小
		Dimension dimension = Toolkit.getDefaultToolkit().getScreenSize();		//获得屏幕尺寸
		frame.setLocation((dimension.width-image.getIconWidth())/2,(dimension.height-image.getIconHeight())/2);	//置于屏幕中央
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);					//默认关闭
		
		//添加背景图片
		JLayeredPane layer = new JLayeredPane();
		JLabel imJLabel = new JLabel(image);
		JPanel imJPanel = new JPanel();
		imJPanel.add(imJLabel);
		imJPanel.setBounds(0,0,image.getIconWidth(),image.getIconHeight());
		layer.add(imJPanel, JLayeredPane.DEFAULT_LAYER);
		
		//添加选择按钮
		add.setBackground(Color.LIGHT_GRAY);
		add.setFont(new Font("华文行楷",Font.CENTER_BASELINE,25));
		add.setForeground(Color.ORANGE);
		add.setBorder(BorderFactory.createRaisedBevelBorder());
		add.setOpaque(false);
		add.setBounds(10,30,150,50);
		layer.add(add,JLayeredPane.MODAL_LAYER);
		add.addActionListener(this);
		
		//添加选择按钮
		start.setBackground(Color.LIGHT_GRAY);
		start.setFont(new Font("华文行楷",Font.CENTER_BASELINE,25));
		start.setForeground(Color.ORANGE);
		start.setBorder(BorderFactory.createRaisedBevelBorder());
		start.setOpaque(false);
		start.setBounds(200,100,150,50);
		layer.add(start,JLayeredPane.MODAL_LAYER);
		start.addActionListener(this);
		
		//添加文件名路径显示框
		showFileName.setOpaque(false);
		showFileName.setFont(new Font("楷书",Font.CENTER_BASELINE,20));
		showFileName.setForeground(Color.DARK_GRAY);
		showFileName.setBorder(new LineBorder(Color.CYAN, 1, true));
		showFileName.setBounds(170,30,400,50);									   
		layer.add(showFileName, JLayeredPane.MODAL_LAYER);
		
		frame.add(layer);
		frame.setVisible(true);
	}

	public void actionPerformed(ActionEvent e) 
	{
		if(e.getSource() == add)						//判断按下了选择按钮
		{
			JFileChooser chooser = new JFileChooser();	//新建文件选择器
			chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
			chooser.setCurrentDirectory(new File("."));
			chooser.setFileFilter(new FileFilter()		//只选择txt文件
					{
						public boolean accept(File file)
						{
							String fileName = file.getName().toLowerCase();
							return fileName.endsWith(".txt") || fileName.endsWith(".asm") || file.isDirectory();
						}
						public String getDescription()
						{
							return "文本文件,MIPS文件(*.txt,*.asm)";
						}
					});
			if(chooser.showOpenDialog(Frame.this) == JFileChooser.APPROVE_OPTION)
			{
				fileName = chooser.getSelectedFile().getAbsolutePath();
				showFileName.setText(fileName);			//获取绝对路径并显示在文本框中
			}
		}
		else if(e.getSource() == start)					//判断按下了开始编译按钮
		{
			Compiler compiler = new Compiler(fileName);
			compiler.complierMIPS();
			JOptionPane.showMessageDialog(null, "编译结束");
		}
	}
}
