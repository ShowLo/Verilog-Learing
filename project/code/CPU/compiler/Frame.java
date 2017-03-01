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
	JButton add = new JButton("ѡ���ļ�");					//����ļ���ť
	JButton start = new JButton("��ʼ����");				//��ӱ��밴ť
	JTextField showFileName = new JTextField(40);		//��ʾ�ļ�·��
	String fileName;									//ѡ����ļ���
	
	public String getFileName()							//���صõ����ļ���
	{
		return fileName;
	}
	
	public Frame()										//����������������
	{
		JFrame frame = new JFrame("������");
		ImageIcon image = new ImageIcon("sea.jpg");					//����ͼƬ
		frame.setSize(image.getIconWidth(),image.getIconHeight());				//���ô�С
		Dimension dimension = Toolkit.getDefaultToolkit().getScreenSize();		//�����Ļ�ߴ�
		frame.setLocation((dimension.width-image.getIconWidth())/2,(dimension.height-image.getIconHeight())/2);	//������Ļ����
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);					//Ĭ�Ϲر�
		
		//��ӱ���ͼƬ
		JLayeredPane layer = new JLayeredPane();
		JLabel imJLabel = new JLabel(image);
		JPanel imJPanel = new JPanel();
		imJPanel.add(imJLabel);
		imJPanel.setBounds(0,0,image.getIconWidth(),image.getIconHeight());
		layer.add(imJPanel, JLayeredPane.DEFAULT_LAYER);
		
		//���ѡ��ť
		add.setBackground(Color.LIGHT_GRAY);
		add.setFont(new Font("�����п�",Font.CENTER_BASELINE,25));
		add.setForeground(Color.ORANGE);
		add.setBorder(BorderFactory.createRaisedBevelBorder());
		add.setOpaque(false);
		add.setBounds(10,30,150,50);
		layer.add(add,JLayeredPane.MODAL_LAYER);
		add.addActionListener(this);
		
		//���ѡ��ť
		start.setBackground(Color.LIGHT_GRAY);
		start.setFont(new Font("�����п�",Font.CENTER_BASELINE,25));
		start.setForeground(Color.ORANGE);
		start.setBorder(BorderFactory.createRaisedBevelBorder());
		start.setOpaque(false);
		start.setBounds(200,100,150,50);
		layer.add(start,JLayeredPane.MODAL_LAYER);
		start.addActionListener(this);
		
		//����ļ���·����ʾ��
		showFileName.setOpaque(false);
		showFileName.setFont(new Font("����",Font.CENTER_BASELINE,20));
		showFileName.setForeground(Color.DARK_GRAY);
		showFileName.setBorder(new LineBorder(Color.CYAN, 1, true));
		showFileName.setBounds(170,30,400,50);									   
		layer.add(showFileName, JLayeredPane.MODAL_LAYER);
		
		frame.add(layer);
		frame.setVisible(true);
	}

	public void actionPerformed(ActionEvent e) 
	{
		if(e.getSource() == add)						//�жϰ�����ѡ��ť
		{
			JFileChooser chooser = new JFileChooser();	//�½��ļ�ѡ����
			chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
			chooser.setCurrentDirectory(new File("."));
			chooser.setFileFilter(new FileFilter()		//ֻѡ��txt�ļ�
					{
						public boolean accept(File file)
						{
							String fileName = file.getName().toLowerCase();
							return fileName.endsWith(".txt") || fileName.endsWith(".asm") || file.isDirectory();
						}
						public String getDescription()
						{
							return "�ı��ļ�,MIPS�ļ�(*.txt,*.asm)";
						}
					});
			if(chooser.showOpenDialog(Frame.this) == JFileChooser.APPROVE_OPTION)
			{
				fileName = chooser.getSelectedFile().getAbsolutePath();
				showFileName.setText(fileName);			//��ȡ����·������ʾ���ı�����
			}
		}
		else if(e.getSource() == start)					//�жϰ����˿�ʼ���밴ť
		{
			Compiler compiler = new Compiler(fileName);
			compiler.complierMIPS();
			JOptionPane.showMessageDialog(null, "�������");
		}
	}
}
