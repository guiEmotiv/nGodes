VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CTemptativePlanEntry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit
'Declare Variables for Attributes
Private m_IDTemptativePlanTask As Integer
Private m_TemptativePlanFinishTaskExec As Single

Property Get IDTemptativePlanTask() As Integer
IDTemptativePlanTask = m_IDTemptativePlanTask
End Property
Property Let IDTemptativePlanTask(IDTPLT As Integer)
m_IDTemptativePlanTask = IDTPLT
End Property
Property Get TemptativePlanFinishTaskExec() As Single
TemptativePlanFinishTaskExec = m_TemptativePlanFinishTaskExec
End Property
Property Let TemptativePlanFinishTaskExec(TPFTE As Single)
m_TemptativePlanFinishTaskExec = TPFTE
End Property

