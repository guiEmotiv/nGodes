VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CTimeStepPlanSet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit
'Declare Variables for Attributes
Private m_TemptativeIterationPlanSets() As Collection
Private m_TemptativeIterationPlanSet As CTemptativeIterationPlansSet
Private m_CurrentTOPScoreCollected As Integer
Private m_CurrentCoverageCollected As Single
Private m_CurrentCoverageCollectedRaw As Single
Private m_CurrentTOPScoreCollectedNormal As Single
Private m_CurrentAlarmScoreCollected As Single
Private ModifiedMaxIterations As Single


'****Private m_maxtemptative_iteration_counter As Integer

'saving variables
Private m_OriginXPositionNextL0() As Single
Private m_OriginYPositionNextL0() As Single
Private m_EmergencyVerifierNextL0() As Boolean
Private m_StartingTaskNextL0() As Single
Private m_SimulationXPositionNextL0() As Single
Private m_SimulationYPositionNextL0() As Single
Private m_LiberationTimeNextL0() As Single



'for displaying guard plans
Private m_LastGuardRowP As Integer
Private m_numexectaskininterval As Integer
'used tasks array
Private m_UsedTasksArray() As Integer

'for displaying historic scores
Private m_MaxPossibleScore As Single
Private m_SelectedTopScore As Single
Private m_NormSelectedTopScore As Single
Private m_SelectedCoverage As Single
Private m_SelectedCombinedScore As Single
Private m_SelectedIteration As Integer

Private guard_counter As Integer

Private hh As Single
Private gh As Single






'save variables for history of selection

Property Get CurrentAlarmScoreCollected() As Integer
CurrentAlarmScoreCollected = m_CurrentAlarmScoreCollected
End Property



Property Get CurrentTOPScoreCollected() As Integer
CurrentTOPScoreCollected = m_CurrentTOPScoreCollected
End Property
Property Get CurrentCoverageCollected() As Single
CurrentCoverageCollected = m_CurrentCoverageCollected
End Property

Property Get CurrentCoverageCollectedRaw() As Single
CurrentCoverageCollectedRaw = m_CurrentCoverageCollectedRaw
End Property


Property Get OriginXPositionNextL0(varguard_counter1 As Integer) As Single
OriginXPositionNextL0 = m_OriginXPositionNextL0(varguard_counter1)
End Property
Public Function OriginXPositionNextfL0(varguard_counter1 As Integer) As Single
OriginXPositionNextfL0 = m_OriginXPositionNextL0(varguard_counter1)
End Function

Property Get OriginYPositionNextL0(varguard_counter2 As Integer) As Single
OriginYPositionNextL0 = m_OriginYPositionNextL0(varguard_counter2)
End Property
Public Function OriginYPositionNextfL0(varguard_counter2 As Integer) As Single
OriginYPositionNextfL0 = m_OriginYPositionNextL0(varguard_counter2)
End Function
Property Get EmergencyVerifierNextL0(varguard_counter3 As Integer) As Boolean
EmergencyVerifierNextL0 = m_EmergencyVerifierNextL0(varguard_counter3)
End Property
Public Function EmergencyVerifierNextfL0(varguard_counter3 As Integer) As Boolean
EmergencyVerifierNextfL0 = m_EmergencyVerifierNextL0(varguard_counter3)
End Function

Property Get StartingTaskNextL0(varguard_counter4 As Integer) As Single
StartingTaskNextL0 = m_StartingTaskNextL0(varguard_counter4)
End Property
Public Function StartingTaskNextfL0(varguard_counter4 As Integer) As Single
StartingTaskNextfL0 = m_StartingTaskNextL0(varguard_counter4)
End Function

Property Get SimulationXPositionNextL0(varguard_counter5 As Integer) As Single
SimulationXPositionNextL0 = m_SimulationXPositionNextL0(varguard_counter5)
End Property
Public Function SimulationXPositionNextfL0(varguard_counter5 As Integer) As Single
SimulationXPositionNextfL0 = m_SimulationXPositionNextL0(varguard_counter5)
End Function
Property Get SimulationYPositionNextL0(varguard_counter5a As Integer) As Single
SimulationYPositionNextL0 = m_SimulationYPositionNextL0(varguard_counter5a)
End Property
Public Function SimulationYPositionNextfL0(varguard_counter5a As Integer) As Single
SimulationYPositionNextfL0 = m_SimulationYPositionNextL0(varguard_counter5a)
End Function
Property Get LiberationTimeNextL0(varguard_counter6 As Integer) As Single
LiberationTimeNextL0 = m_LiberationTimeNextL0(varguard_counter6)
End Property
Public Function LiberationTimeNextfL0(varguard_counter6 As Integer) As Single
LiberationTimeNextfL0 = m_LiberationTimeNextL0(varguard_counter6)
End Function
Property Get LastGuardRowP() As Single
LastGuardRowP = m_LastGuardRowP
End Property
Property Get numexectaskininterval() As Integer
numexectaskininterval = m_numexectaskininterval
End Property
Property Get UsedTasksArray(var_tsk As Integer) As Integer
UsedTasksArray = m_UsedTasksArray(var_tsk)
End Property
Public Function UsedTasksArrayf(var_tsk As Integer) As Integer
UsedTasksArrayf = m_UsedTasksArray(var_tsk)
End Function
Property Get MaxPossibleScore() As Single
MaxPossibleScore = m_MaxPossibleScore
End Property
Property Get SelectedTopScore() As Single
SelectedTopScore = m_SelectedTopScore
End Property
Property Get NormSelectedTopScore() As Single
NormSelectedTopScore = m_NormSelectedTopScore
End Property
Property Get SelectedCoverage() As Single
SelectedCoverage = m_SelectedCoverage
End Property
Property Get SelectedCombinedScore() As Single
SelectedCombinedScore = m_SelectedCombinedScore
End Property
Property Get SelectedIteration() As Integer
SelectedIteration = m_SelectedIteration
End Property
Property Get CurrentTOPScoreCollectedNormal() As Integer
CurrentTOPScoreCollectedNormal = m_CurrentTOPScoreCollectedNormal
End Property


Public Sub Class_Initialize()


m_CurrentTOPScoreCollected = 0
m_CurrentCoverageCollected = 0

m_LastGuardRowP = 10

ReDim Preserve m_TemptativeIterationPlanSets(UpperBoundforTimeStepPlan + 1)

Set m_TemptativeIterationPlanSets(TimeStepPlan_Counter) = New Collection

For temptative_iteration_counter = 1 To max_concurrentiteration_counter
    Set m_TemptativeIterationPlanSet = New CTemptativeIterationPlansSet
    m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Add m_TemptativeIterationPlanSet
Next temptative_iteration_counter

ReDim m_ExecutedPlansID(1 To 1)

ReDim m_OriginXPositionNextL0(MaxGuards)
ReDim m_OriginYPositionNextL0(MaxGuards)
ReDim m_EmergencyVerifierNextL0(MaxGuards)
ReDim m_StartingTaskNextL0(MaxGuards)
ReDim m_SimulationXPositionNextL0(MaxGuards)
ReDim m_SimulationYPositionNextL0(MaxGuards)
ReDim m_LiberationTimeNextL0(MaxGuards)


'initialize saving protected time paramters
For guard_counter = 1 To MaxGuards
    m_OriginXPositionNextL0(guard_counter) = 0
    m_OriginYPositionNextL0(guard_counter) = 0
    m_EmergencyVerifierNextL0(guard_counter) = False
    m_StartingTaskNextL0(guard_counter) = 0
    m_SimulationXPositionNextL0(guard_counter) = 0
    m_SimulationYPositionNextL0(guard_counter) = 0
    m_LiberationTimeNextL0(guard_counter) = 0
Next guard_counter

m_CurrentTOPScoreCollected = 0

ReDim Preserve m_UsedTasksArray(LastAlarmTaskID)

For i = 1 To LastAlarmTaskID
    m_UsedTasksArray(i) = 0
Next i

'initialize display of history
m_MaxPossibleScore = 0
m_SelectedTopScore = 0
m_NormSelectedTopScore = 0
m_SelectedCoverage = 0
m_SelectedCombinedScore = 0

m_SelectedIteration = 1

End Sub
Public Sub ConstructNewPlans(StartVirtualTime As Single, _
 FinishVirtualTime As Single, VirtualTimeStep As Single, _
 StardardRadius As Single, EmergencyDuration As Single, _
 AllGuardsID() As Integer, AvailableTasksID() As Integer)

Dim VirtualTimeStepL1 As Single
Dim StartVirtualTimeL1 As Single
Dim FinishVirtualTimeL1 As Single
Dim AllGuardsIDL1() As Integer
Dim AvailableTasksIdL1() As Integer
Dim SelectedCombinedScore As Single
Dim TopScoreforIteration() As Single
Dim NormTopScoreforIteration() As Single
Dim CoverageforIteration() As Single
Dim CombinedScoreforIteration() As Single
Dim SelectedTopScore As Single
Dim SelectedCoverage As Single
Dim SelectedIteration As Integer
Dim i As Integer

'For printing history, comment later
Sheets("SelectionHistory").Select


'Passing arguments to next level
VirtualTimeStepL1 = VirtualTimeStep
StartVirtualTimeL1 = ((Int((CurrentAlarmTime - 0.000001) / VirtualTimeStep) + 1) * VirtualTimeStep) + 0.000001
FinishVirtualTimeL1 = FinishVirtualTime
'#check if this array passing is really necessary
ReDim AllGuardsIDL1(1 To MaxGuards)
For i = 1 To MaxGuards
    AllGuardsIDL1(i) = AllGuardsID(i)
Next i
ReDim AvailableTasksIdL1(UBound(AvailableTasksID()))


m_MaxPossibleScore = 0
For i = 1 To UBound(AvailableTasksID())
    AvailableTasksIdL1(i) = AvailableTasksID(i)
    m_MaxPossibleScore = Task(AvailableTasksIdL1(i)).Importance + MaxPossibleScore
Next i

'Initialize Selected Combined Score
m_SelectedCombinedScore = 0

'faster procedure
If UBound(AvailableTasksID()) > 9 Then
    ModifiedMaxIterations = max_concurrentiteration_counter
Else
    If UBound(AvailableTasksID()) > 7 Then
        ModifiedMaxIterations = max_concurrentiteration_counter * 0.7
    Else
        ModifiedMaxIterations = max_concurrentiteration_counter * 0.5
    End If
End If
    
    

ReDim TopScoreforIteration(1 To ModifiedMaxIterations)
ReDim CoverageforIteration(1 To ModifiedMaxIterations)
ReDim CombinedScoreforIteration(1 To ModifiedMaxIterations)
ReDim NormTopScoreforIteration(1 To ModifiedMaxIterations)

'2.1.1 Create Iteration Plans Concurrent for Next Iterations
For temptative_iteration_counter = 1 To ModifiedMaxIterations
        
    'MsgBox "iteration" & temptative_iteration_counter
    
    'Construct tasks concurrent
    Call m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(temptative_iteration_counter).ConcurrentProcedure(temptative_iteration_counter, StartVirtualTimeL1, AvailableTasksID())
    
    'Calculate coverage
    Call m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(temptative_iteration_counter).CalculateCoverageScore(temptative_iteration_counter, StartVirtualTimeL1, FinishVirtualTimeL1, VirtualTimeStepL1, StandardRadius, EmergencyDuration, AllGuardsID())
   
   
   'Select best
    TopScoreforIteration(temptative_iteration_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(temptative_iteration_counter).TOPScore
    
    'Avoid division by zero (no longer necessary)
    If m_MaxPossibleScore = 0 Then
        NormTopScoreforIteration(temptative_iteration_counter) = 0
   Else
        NormTopScoreforIteration(temptative_iteration_counter) = (TopScoreforIteration(temptative_iteration_counter)) / m_MaxPossibleScore
    End If
    
    
    CoverageforIteration(temptative_iteration_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(temptative_iteration_counter).CoverageScore
    
    
    If RunMode = 1 Then
        CombinedScoreforIteration(temptative_iteration_counter) = TopScoreforIteration(temptative_iteration_counter)
    Else
        If RunMode = 2 Then
            CombinedScoreforIteration(temptative_iteration_counter) = TopScoreforIteration(temptative_iteration_counter) * 1 + CoverageforIteration(temptative_iteration_counter) * A_emerdimportance * 0.00001
        Else
            If RunMode = 3 Then
                CombinedScoreforIteration(temptative_iteration_counter) = TopScoreforIteration(temptative_iteration_counter) * 1 + CoverageforIteration(temptative_iteration_counter) * A_emerdimportance * 1
            Else
                If RunMode = 4 Then
                        CombinedScoreforIteration(temptative_iteration_counter) = TopScoreforIteration(temptative_iteration_counter) * 1 + CoverageforIteration(temptative_iteration_counter) * A_emerdimportance * 1
                    Else
                        CombinedScoreforIteration(temptative_iteration_counter) = TopScoreforIteration(temptative_iteration_counter) * 0.00001 + CoverageforIteration(temptative_iteration_counter) * A_emerdimportance * 1
                    End If
            End If
        End If
     End If
                
     'PrintScores
     If ShowDetails = 1 Then
            Cells(3 + temptative_iteration_counter, 1) = TopScoreforIteration(temptative_iteration_counter)
            Cells(3 + temptative_iteration_counter, 2) = CoverageforIteration(temptative_iteration_counter)
            Cells(3 + temptative_iteration_counter, 3) = CombinedScoreforIteration(temptative_iteration_counter)
    Else
    End If
                
                
                
    
    
   '* add integration factor
   
    'Verify if it is the best
    If CombinedScoreforIteration(temptative_iteration_counter) > m_SelectedCombinedScore Then
        m_SelectedTopScore = TopScoreforIteration(temptative_iteration_counter)
        m_NormSelectedTopScore = NormTopScoreforIteration(temptative_iteration_counter)
        m_SelectedCoverage = CoverageforIteration(temptative_iteration_counter)
        m_SelectedCombinedScore = CombinedScoreforIteration(temptative_iteration_counter)
        m_SelectedIteration = temptative_iteration_counter
        'MsgBox "Selected Iteration " & m_SelectedIteration
    Else
    End If
    
Next temptative_iteration_counter
 
  
  
  
End Sub
Public Sub PlanStatusVerification(PrevAlarmTime, CurrentAlarmTime As Single, VirtualTimeStep As Single, LastGuardRow As Integer)

Dim ForwardTime As Single

Dim maxmax_taskcounter As Integer
Dim max_taskcounter As Integer
Dim task_counter As Integer
Dim guard_counter As Integer
Dim StartDisplayTime As Single
Dim timestep_counter As Integer
Dim site_counter As Integer
Dim StartingDisplayStep As Integer


Dim x As Single
Dim y As Single
Dim yy As String


Dim g As Single
Dim h As Single
Dim zzz As Integer

Dim k As Integer


'0. Identify number of iteration that has been selected.
selected_iteration_counter = m_SelectedIteration
 
'1. Call procedure to assign X, Y position of each guard & LiberationTime (Next)

Call m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).PlanStatusVerificationL1(CurrentAlarmTime, selected_iteration_counter)

'2. Retrieve X,Y & Liberation Time values (Next)


For guard_counter = 1 To MaxGuards
     
     
     m_OriginXPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).OriginXPositionNextfL1(guard_counter)
     m_OriginYPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).OriginYPositionNextfL1(guard_counter)
     m_EmergencyVerifierNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).EmergencyVerifierNextfL1(guard_counter)
     m_StartingTaskNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).StartingTaskNextfL1(guard_counter)
     m_SimulationXPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).SimulationXPositionNextfL1(guard_counter)
     m_SimulationYPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).SimulationYPositionNextfL1(guard_counter)
     m_LiberationTimeNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).LiberationTimeNextfL1(guard_counter)
                
Next guard_counter


'3. Retrieve collected TOP Score



m_CurrentTOPScoreCollected = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).CollectedTopScore

m_CurrentTOPScoreCollectedNormal = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).CollectedTopScoreNormal


 m_CurrentAlarmScoreCollected = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).CollectedAlarmScore





'4. Retrieve & Consolidate Executed Tasks

    
'4.1 Consolidate Array of Accomplished Tasks & Display Plans

maxmax_taskcounter = 0
Sheets("Results").Select

i = 0


For guard_counter = 1 To MaxGuards
    
    'Identify maximum counter of tasks
    max_taskcounter = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).LastTaskCounterfL0(guard_counter)
    
    k = 0
    
    For task_counter = 2 To max_taskcounter
        i = i + 1
       'initialized accomplished tasks
        ReDim Preserve m_UsedTasksArray(i)
        
        m_UsedTasksArray(i) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).IterationAccomplishedTasksf(guard_counter, task_counter)
        'Display Guard Plan
        zzz = TimeStepPlan_Counter - 1
        'MsgBox "TimeStepPlan " & zzz & "GuardCounter " & guard_counter & "TaskID " & m_UsedTasksArray(i)
        
        
        
        If m_UsedTasksArray(i) <> 0 Then
            k = k + 1
            Cells(LastGuardRow + k, guard_counter + 8) = m_UsedTasksArray(i) & " Int " & TimeStepPlan_Counter - 1
        Else
        End If
        
    Next task_counter
    
    'save maximum length of guards among all guards
    
    
    If k > maxmax_taskcounter Then
        maxmax_taskcounter = k
    Else
    End If
    
Next guard_counter
m_numexectaskininterval = i

m_LastGuardRowP = maxmax_taskcounter + LastGuardRow

'5. Retrieve collected Coverage Score

'5.1 Set starting values

If TimeStepPlan_Counter > 2 Then
    StartDisplayTime = ((Int((PrevAlarmTime) / VirtualTimeStep)) * VirtualTimeStep) + 0.000001 + VirtualTimeStep
    StartingDisplayStep = (Int((PrevAlarmTime) / VirtualTimeStep)) + 1
    ForwardTime = StartDisplayTime
    
Else
    StartDisplayTime = 0.000001
    ForwardTime = StartDisplayTime
    StartingDisplayStep = 0
End If

timestep_counter = 1

Sheets("CoverageDetail").Select

'5.2 Display Coverage in Excel


Do While ForwardTime < CurrentAlarmTime

    'Display Time Steps
    If ShowDetails = 1 Then
    
    Cells(3 + StartingDisplayStep + timestep_counter, 2) = ForwardTime
    
    'Display Guard Coordinates
    For guard_counter = 1 To MaxGuards
        x = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).ActualPositionfX(timestep_counter, guard_counter)
        y = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).ActualPositionfY(timestep_counter, guard_counter)
        yy = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).ActualGuardStatusf(timestep_counter, guard_counter)
        Cells(3 + StartingDisplayStep + timestep_counter, 3 * guard_counter) = x
        Cells(3 + StartingDisplayStep + timestep_counter, 3 * guard_counter + 1) = y
        Cells(3 + StartingDisplayStep + timestep_counter, 3 * guard_counter + 2) = yy
    Next guard_counter
    
    'Display Coverage per Site per Time Step
    For site_counter = 1 To MaxSites - 1
        'Coverage per site
        g = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).SiteCoveredf(timestep_counter, site_counter)
        Cells(3 + StartingDisplayStep + timestep_counter, 16 + site_counter) = g
    Next site_counter
    Else
    End If
    
    
    
    
    'Display Coverage per Time Step Raw
    gh = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).CoverageforTimeStepRaw(timestep_counter)
    
    If ShowDetails = 1 Then
    Cells(3 + StartingDisplayStep + timestep_counter, 16 + MaxSites + 2) = gh
    Else
    End If

    'Display Coverage per Time Step
    h = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).CoverageforTimeStep(timestep_counter)

    
    
   If ShowDetails = 1 Then
    Cells(3 + StartingDisplayStep + timestep_counter, 16 + MaxSites + 3) = h
  Else
  End If
  
  
  If ShowDetails = 1 Then
    'Display Survival probability
    hh = m_TemptativeIterationPlanSets(TimeStepPlan_Counter - 1).Item(selected_iteration_counter).SurvivalforTimeStep(timestep_counter)
    Cells(3 + StartingDisplayStep + timestep_counter, 16 + MaxSites + 4) = hh
    Else
    End If
    
    'Save cummulative Coverage Raw
    m_CurrentCoverageCollectedRaw = gh + m_CurrentCoverageCollectedRaw
    
    
    'Save Cummulative Coverage
    m_CurrentCoverageCollected = h + m_CurrentCoverageCollected
    
    'Update forward time and step counter
    ForwardTime = ForwardTime + VirtualTimeStep
    timestep_counter = timestep_counter + 1
Loop



End Sub


Public Sub PlanStatusVerificationLastLeg(PrevAlarmTime, CurrentAlarmTime As Single, VirtualTimeStep As Single, LastGuardRow As Integer)

Dim ForwardTime As Single

Dim maxmax_taskcounter As Integer
Dim max_taskcounter As Integer
Dim task_counter As Integer
Dim guard_counter As Integer
Dim StartDisplayTime As Single
Dim timestep_counter As Integer
Dim site_counter As Integer
Dim StartingDisplayStep As Integer


Dim x As Single
Dim y As Single
Dim yy As String

Dim g As Single
Dim h As Single
Dim k As Integer

Dim zzz As Integer



'0. Identify number of iteration that has been selected.
selected_iteration_counter = m_SelectedIteration
 
'1. Call procedure to assign X, Y position of each guard & LiberationTime (Next)



Call m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).PlanStatusVerificationL1(CurrentAlarmTime, selected_iteration_counter)

'2. Retrieve X,Y & Liberation Time values (Next)
For guard_counter = 1 To MaxGuards
     
     
     m_OriginXPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).OriginXPositionNextfL1(guard_counter)
     m_OriginYPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).OriginYPositionNextfL1(guard_counter)
     m_EmergencyVerifierNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).EmergencyVerifierNextfL1(guard_counter)
     m_StartingTaskNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).StartingTaskNextfL1(guard_counter)
     m_SimulationXPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).SimulationXPositionNextfL1(guard_counter)
     m_SimulationYPositionNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).SimulationYPositionNextfL1(guard_counter)
     m_LiberationTimeNextL0(guard_counter) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).LiberationTimeNextfL1(guard_counter)
                
Next guard_counter


'3. Retrieve collected TOP Score

m_CurrentTOPScoreCollected = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).CollectedTopScore

m_CurrentTOPScoreCollectedNormal = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).CollectedTopScoreNormal


 m_CurrentAlarmScoreCollected = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).CollectedAlarmScore



'4. Retrieve & Consolidate Executed Tasks

    
'4.1 Consolidate Array of Accomplished Tasks & Display Plans

maxmax_taskcounter = 0
Sheets("Results").Select

i = 0


For guard_counter = 1 To MaxGuards
    
    'Identify maximum counter of tasks
    max_taskcounter = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).LastTaskCounterfL0(guard_counter)

    k = 0
    For task_counter = 2 To max_taskcounter
        i = i + 1
        ReDim Preserve m_UsedTasksArray(i)
        m_UsedTasksArray(i) = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).IterationAccomplishedTasksf(guard_counter, task_counter)
        'Display Guard Plan
        zzz = TimeStepPlan_Counter
        'MsgBox "TimeStepPlan " & zzz & "GuardCounter " & guard_counter & "TaskID " & m_UsedTasksArray(i)
        
        
        If m_UsedTasksArray(i) <> 0 Then
            k = k + 1
            Cells(LastGuardRow + k, guard_counter + 8) = m_UsedTasksArray(i) & " Int " & TimeStepPlan_Counter
        Else
        End If
        
    Next task_counter
    
    'save maximum length of guards among all guards
    
    
    If k > maxmax_taskcounter Then
        maxmax_taskcounter = k
    Else
    End If
    
Next guard_counter
m_numexectaskininterval = i


m_LastGuardRowP = maxmax_taskcounter + LastGuardRow

m_CurrentCoverageCollected = 0


'5. Retrieve collected Coverage Score

'5.1 Set starting values
If TimeStepPlan_Counter > 1 Then
    StartDisplayTime = ((Int((PrevAlarmTime) / VirtualTimeStep)) * VirtualTimeStep) + 0.000001 + VirtualTimeStep
    StartingDisplayStep = (Int((PrevAlarmTime) / VirtualTimeStep)) + 1
    ForwardTime = StartDisplayTime
Else
    StartDisplayTime = 0.000001
    ForwardTime = StartDisplayTime
    StartingDisplayStep = (Int((PrevAlarmTime) / VirtualTimeStep))
End If

timestep_counter = 1

Sheets("CoverageDetail").Select




'5.2 Display Coverage in Excel
Do While ForwardTime < CurrentAlarmTime
    
    If ShowDetails = 1 Then
    
    'Display Time Steps
    Cells(3 + StartingDisplayStep + timestep_counter, 2) = ForwardTime
    
    'Display Guard Coordinates
    For guard_counter = 1 To MaxGuards
        x = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).ActualPositionfX(timestep_counter, guard_counter)
        y = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).ActualPositionfY(timestep_counter, guard_counter)
        yy = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).ActualGuardStatusf(timestep_counter, guard_counter)
        
        Cells(3 + StartingDisplayStep + timestep_counter, 3 * guard_counter) = x
        Cells(3 + StartingDisplayStep + timestep_counter, 3 * guard_counter + 1) = y
        Cells(3 + StartingDisplayStep + timestep_counter, 3 * guard_counter + 2) = yy
    Next guard_counter
    
    'Display Coverage per Site per Time Step
    For site_counter = 1 To MaxSites - 1
        'Coverage per site
        g = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).SiteCoveredf(timestep_counter, site_counter)
        Cells(3 + StartingDisplayStep + timestep_counter, 16 + site_counter) = g
    Next site_counter
    Else
    End If


    'Display Coverage per Time Step Raw
    gh = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).CoverageforTimeStepRaw(timestep_counter)
    
    If ShowDetails = 1 Then
    Cells(3 + StartingDisplayStep + timestep_counter, 16 + MaxSites + 2) = gh
    Else
    End If
    
    'Display Coverage per Time Step
    h = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).CoverageforTimeStep(timestep_counter)
    
    If ShowDetails = 1 Then
    Cells(3 + StartingDisplayStep + timestep_counter, 16 + MaxSites + 3) = h
    Else
    End If
    
    
    If ShowDetails = 1 Then
    'Display Survival probability
    hh = m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(selected_iteration_counter).SurvivalforTimeStep(timestep_counter)
    Cells(3 + StartingDisplayStep + timestep_counter, 16 + MaxSites + 4) = hh
    Else
    End If
    
  'Save cummulative Coverage Raw
    m_CurrentCoverageCollectedRaw = gh + m_CurrentCoverageCollectedRaw
    
    'Save Cummulative Coverage
    m_CurrentCoverageCollected = h + m_CurrentCoverageCollected
    
    'Update forward time and step counter
    ForwardTime = ForwardTime + VirtualTimeStep
    timestep_counter = timestep_counter + 1
Loop



End Sub
Public Sub InitializeParameters(OriginXPositionM() As Single, OriginYPositionM() As Single, EmergencyVerifierM() As Boolean, StartingTaskM() As Single, SimulationXPositionM() As Single, SimulationYPositionM() As Single, LiberationTimeM() As Single)



'function for initializing paramters
For temptative_iteration_counter = 1 To max_concurrentiteration_counter
    Call m_TemptativeIterationPlanSets(TimeStepPlan_Counter).Item(temptative_iteration_counter).InitializeParametersL1(OriginXPositionM(), OriginYPositionM(), EmergencyVerifierM(), StartingTaskM(), SimulationXPositionM(), SimulationYPositionM(), LiberationTimeM())
Next temptative_iteration_counter

End Sub


