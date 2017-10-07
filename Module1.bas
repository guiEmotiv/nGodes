Attribute VB_Name = "Module1"
'0 Declarations
'0.1 Declarations of variable objects: sites, tasks and guards
Public i As Integer
Public Site(0 To 300) As CSite
Public Task(0 To 300) As CTask
Public guard(1 To 30) As CGuard
Public TimeStepPlan() As CTimeStepPlanSet
'*Public TemptativeIterationPlansSet(1 To 3000) As CTemptativeIterationPlansSet
'0.2Declarations of maximum constants
Public MaxSites As Integer
Public MaxGuards As Integer
Public Maxordtasks As Integer
Public IntegrationFactor As Single
Public IntegrationFactorTOP As Single
Public TimeweightedTOPFactor As String

Public ShowDetails As Single

Public MinimumDistance As Single


'RUN MODE
Public RunMode As Single

'UNIVERSAL
Public temptative_iteration_counter As Integer
Public selected_iteration_counter As Integer


Public AllGuardsID() As Integer
Public AvailableTasksID() As Integer
Public max_concurrentiteration_counter As Integer
Public TerminationTime As Single
Public EmergencyDeterministicDuration As Single
Public BaseReturn As Boolean
Public MeanRateAlarmsperShift As Single
Public EmergencyDuration As Single
Public StandardRadius As Single
Public ImportanceforAlarms As Single
'Public maxtemptative_iteration_counter As Integer
Public MaxSteps As Integer
Public VirtualTimeStep As Single
Public MaxAvailableTasks As Integer

Public A_emerdimportance As Single




'Parameters
Public FirstAlarmTaskID As Integer
Public LastAlarmTaskID As Integer

'Universal Plan Counter
Public TimeStepPlan_Counter As Integer

'Universal Upperbound of plans
Public UpperBoundforTimeStepPlan As Integer

'Universal CurrentAlarmTime
Public CurrentAlarmTime As Single

'Extra coverage factors
Public Denominator As Single
Public DiscountIndicator As Integer
Public StepDiscountFactor As Single


Sub GenerateAlarms()
'Sites Coordinates
Dim AProv_SiteCoordinateX(300) As Single
Dim AProv_SiteCoordinateY(300) As Single

'Alarm Parmeters
Dim AProv_TimeShift As Single
Dim A_MeanRate As Single
Dim A_alarmsite(300) As Integer
Dim A_interarrival(300) As Single
Dim A_alarmtime(300) As Single
Dim A_upperbound(300) As Single

Dim A_emerduration As Single

Dim u As Single
Dim i As Integer
Dim MinimumDistanceAlarm As Single


'Task Dimensions
Dim Alarm_TaskSite(300) As Integer
Dim Alarm_TaskRelease(300) As Single
Dim Alarm_TaskEarliest(300) As Single
Dim Alarm_TaskLatest(300) As Single
Dim Alarm_TaskDuration(300) As Single
Dim Alarm_TaskReward(300) As Single

'Maximum number of sites
Sheets("Geography").Select
MaxSites = Range("c1").Value

'Read Sites
For i = 1 To MaxSites - 1
    AProv_SiteCoordinateX(i) = Cells(4 + i, 3)
    AProv_SiteCoordinateY(i) = Cells(4 + i, 4)
Next i


'Generate Alarms
Sheets("Parameters").Select
AProv_TimeShift = Range("b4")
A_MeanRate = Range("b12")
A_emerduration = Range("b13")
A_emerdimportance = Range("b15")
MinimumDistanceAlarm = Range("f9")


'ReadMaxOrd
Sheets("Ordinary Tasks").Select
Maxordtasks = Range("d5")

Sheets("Emergency Tasks").Select
Randomize
i = 0
A_alarmtime(i) = 0

Do While A_alarmtime(i) <= (AProv_TimeShift - A_emerduration - MinimumDistanceAlarm)
i = i + 1
A_interarrival(i) = -Log(Rnd) * ((AProv_TimeShift) / A_MeanRate)
A_alarmtime(i) = A_interarrival(i) + A_alarmtime(i - 1)

Randomize
A_alarmsite(i) = 0
u = Rnd

If A_alarmtime(i) < AProv_TimeShift Then

    For j = 1 To MaxSites - 1
        A_upperbound(j) = (1 / (MaxSites - 1) * (j))
        
        If u < A_upperbound(j) Then
            If u >= A_upperbound(j - 1) Then
                A_alarmsite(i) = j
                Exit For
            Else
            End If
        Else
        End If
    Next j
    
    Cells(9 + i, 2).Value = i + Maxordtasks
    Cells(9 + i, 3).Value = A_alarmsite(i)
    Cells(9 + i, 6).Value = A_alarmtime(i)
    Cells(9 + i, 9).Value = A_emerduration
    Cells(9 + i, 10).Value = A_emerdimportance
Else
End If
    
Loop

End Sub

Sub Main()
Attribute Main.VB_Description = "Macro recorded 22-6-2006 by Administrator"
Attribute Main.VB_ProcData.VB_Invoke_Func = " \n14"
'Main Program

Dim StartVirtualTime As Single
Dim FinishVirtualTime As Single
Dim timestep_counter As Integer

Dim alarm_counter As Integer
Dim guard_counter As Integer
Dim x As Single
Dim y As Single
Dim g As Single
Dim h As Single
Dim z As Single
Dim a As Single
Dim MaxNormalTopScore As Single

'saving variables
Dim OriginXPositionM() As Single
Dim OriginYPositionM() As Single
Dim EmergencyVerifierM() As Boolean
Dim StartingTaskM() As Single
Dim SimulationXPositionM() As Single
Dim SimulationYPositionM() As Single
Dim LiberationTimeM() As Single
Dim MaximumPossibleScore As Single


Dim AverageCuummulativeCoverage As Single

Dim RFakeTask As Single
Dim ROriginXPosition As Single
Dim ROriginYPosition As Single

Dim PrevAlarmTime As Single
Dim LastGuardRow As Integer
Dim NumTaskininterval As Integer
Dim OverallAccomplishedTasks() As Integer
Dim RealCummulativeReward As Single
Dim RealCummulativeCoverage As Single
Dim NumberofSampleIntervals As Integer
Dim AverageCummulativeCoverage As Single
Dim MaximumPossibleTopScore As Single
Dim NormalizedTopScore As Single
Dim RealCummulativeRewardNormal As Single
Dim RealCummulativeRewardAlarms As Single
Dim MinDistanceAlarm As Single




Dim t As Single

Dim start_time As Single
Dim end_time As Single

'for displaying history of scores
Dim HistoryRow As Integer

Application.ScreenUpdating = False

start_time = timer


'1. World Initialization

'1.1 Read Sites-Create Site objects
Sheets("Geography").Select
MaxSites = CInt(Range("c1").Value)
For i = 0 To MaxSites - 1
    Set Site(i) = New CSite
    Denominator = Site(i).RelativeFrequency + Denominator
Next i



'1.2 Read Tasks-Create Task Objects
Sheets("Ordinary Tasks").Select
Maxordtasks = CInt(Range("d5").Value)

'1.3 Construct possible ordinary tasks

ReDim Preserve AvailableTasksID(Maxordtasks - 1)

'To verify if it is alarm
Sheets("Emergency Tasks").Select
FirstAlarmTaskID = Range("h4").Value

'Create Ordinary Tasks Objects
For i = 0 To Maxordtasks - 1
    Set Task(i) = New CTask
    'to not include fake task
    If i > 0 Then
        AvailableTasksID(i) = Task(i).IDTask
    Else
    End If
    MaxNormalTopScore = CSng(Cells(10 + i, 10)) + MaxNormalTopScore
Next i

'1.4 Create Guard Objects
Sheets("Parameters").Select
MaxGuards = CInt(Range("b5").Value)
ReDim Preserve AllGuardsID(1 To MaxGuards)
For i = 1 To MaxGuards
    Set guard(i) = New CGuard
    AllGuardsID(i) = guard(i).IDGuard
Next i
a = UBound(AvailableTasksID())

'1.5 Read Termination Time
TerminationTime = Range("b4").Value
EmergencyDeterministicDuration = Range("b13").Value

'1.6 Read Boolean
If Range("b7").Value = "Yes" Then
    BaseReturn = True
Else
    BaseReturn = False
End If

'1.7 Set Parameters for Coverage Calculations - Real Virtual Time
VirtualTimeStep = Range("b10").Value
StartVirtualTime = 0.00000001
FinishVirtualTime = TerminationTime
MeanRateAlarmsperShift = Range("b12").Value
EmergencyDuration = Range("b13").Value
StandardRadius = Range("b14").Value
ImportanceforAlarms = Range("b15")
IntegrationFactorCoverage = Range("b17")
IntegrationFactorTOP = Range("h17")
DiscountIndicator = Range("d19")
StepDiscountFactor = Range("j10")
TimeweightedTOPFactor = Range("h14")
RunMode = Range("F4")
A_emerdimportance = Range("b15")
ShowDetails = Range("f6")
MinDistanceAlarm = Range("f9")

MaxSteps = Int((TerminationTime - 0.000001) / VirtualTimeStep)
'maximum number of iterations
max_concurrentiteration_counter = Range("b8")




'1.8 Maximum Tasks Available Initialy
MaxAvailableTasks = Maxordtasks - 1

'1.9 Create Alarm Objects
Sheets("Emergency Tasks").Select

FirstAlarmTaskID = Range("h4").Value
LastAlarmTaskID = Range("h5").Value

'Only if they are alarms, expand array
If FirstAlarmTaskID > 0 Then
    For i = FirstAlarmTaskID To LastAlarmTaskID
        Set Task(i) = New CTask
    Next i
    Else
End If

'2. Preliminaries

'2.1 Display Titles
'2.1.1 Display Guards ID
Sheets("Results").Select
For guard_counter = 1 To MaxGuards
    Cells(10, 8 + guard_counter) = "Guard " & guard_counter
Next guard_counter

'2.1.2 Display Guards ID in Next Page
'For guard_counter = 1 To MaxGuards
    'Cells(3, 2 * guard_counter + 1) = "Guard " & guard_counter & " XCoord"
    'Cells(3,2 * guard_counter + 2) = "Guard " & guard_counter & " YCoord"
'Next guard_counter

'2.1.3 Display Sites ID
'For site_counter = 1 To MaxSites
'Cells(3, 2*MaxGuard+4+site_counter)="Site " & "site_counter"
'Next site_counter

'2.2 Redim TimeStepPlan array
ReDim TimeStepPlan(1 To (LastAlarmTaskID - FirstAlarmTaskID + 2)) As CTimeStepPlanSet
UpperBoundforTimeStepPlan = (LastAlarmTaskID - FirstAlarmTaskID + 1)

'2.3 Initialize History Row
HistoryRow = 1

'2.4 Set CurrentAlarm Time to zero
CurrentAlarmTime = 0

'3. Start Simulation
TimeStepPlan_Counter = 1
'3.0 First Set of Plans
'3.0.1 Create new Plan Set

Set TimeStepPlan(1) = New CTimeStepPlanSet

'3.0.2 Set initial Parameters for plans
'3.0.2.1 Dimension arrays
ReDim OriginXPositionM(1 To MaxGuards)
ReDim OriginYPositionM(1 To MaxGuards)
ReDim EmergencyVerifierM(1 To MaxGuards)
ReDim StartingTaskM(1 To MaxGuards)
ReDim SimulationXPositionM(1 To MaxGuards)
ReDim SimulationYPositionM(1 To MaxGuards)
ReDim LiberationTimeM(1 To MaxGuards)

'3.0.2.2 Retrieve Origin Position
RFakeTask = Task(0).IDSite
ROriginXPosition = Site(RFakeTask).XCoordinate
ROriginYPosition = Site(RFakeTask).YCoordinate

For guard_counter = 1 To MaxGuards
    OriginXPositionM(guard_counter) = ROriginXPosition
    OriginYPositionM(guard_counter) = ROriginYPosition
    EmergencyVerifierM(guard_counter) = False
    StartingTaskM(guard_counter) = 0
    SimulationXPositionM(guard_counter) = ROriginXPosition
    SimulationYPositionM(guard_counter) = ROriginYPosition
    LiberationTimeM(guard_counter) = 0
Next guard_counter

'3.0.2.3 Call procedure to imprint initial parameters
Call TimeStepPlan(1).InitializeParameters(OriginXPositionM(), OriginYPositionM(), EmergencyVerifierM(), StartingTaskM(), SimulationXPositionM(), SimulationYPositionM(), LiberationTimeM())



'3.0.3 Call procedure for building plans

Call TimeStepPlan(1).ConstructNewPlans(StartVirtualTime, FinishVirtualTime, VirtualTimeStep, StandardRadius, EmergencyDuration, AllGuardsID(), AvailableTasksID())



'3.0.3 Publish History
Sheets("Results").Select
Cells(10 + HistoryRow, 2) = CurrentAlarmTime
Cells(10 + HistoryRow, 3) = TimeStepPlan(1).SelectedIteration
Cells(10 + HistoryRow, 4) = TimeStepPlan(1).SelectedTopScore
Cells(10 + HistoryRow, 5) = TimeStepPlan(1).NormSelectedTopScore
Cells(10 + HistoryRow, 6) = TimeStepPlan(1).SelectedCoverage
Cells(10 + HistoryRow, 7) = TimeStepPlan(1).SelectedCombinedScore


'3.1 Start Simulation

TimeStepPlan_Counter = 1
LastGuardRow = 10


If FirstAlarmTaskID > 0 Then
    For alarm_counter = FirstAlarmTaskID To LastAlarmTaskID

        '3.1.1 Update counter, current time & prevalarmtime
        CurrentAlarmTime = Task(alarm_counter).Releasing
        'MsgBox "CurrAlarm" & CurrentAlarmTime
        TimeStepPlan_Counter = TimeStepPlan_Counter + 1
        If TimeStepPlan_Counter > 2 Then
            PrevAlarmTime = Task(alarm_counter - 1).Releasing
        Else
        PrevAlarmTime = 0
        End If
    
        '3.1.2 Set Last Row
        If TimeStepPlan_Counter = 2 Then
            LastGuardRow = TimeStepPlan(TimeStepPlan_Counter - 1).LastGuardRowP
        Else
            LastGuardRow = TimeStepPlan(TimeStepPlan_Counter - 2).LastGuardRowP
        End If
        
        'MsgBox "LastGuardRow" & LastGuardRow
        
        '3.1.3 Call Retrieve Status Function
        
        Call TimeStepPlan(TimeStepPlan_Counter - 1).PlanStatusVerification(PrevAlarmTime, CurrentAlarmTime, VirtualTimeStep, LastGuardRow)

        '3.1.4 Save Nexts Parameters
        
        For guard_counter = 1 To MaxGuards
            OriginXPositionM(guard_counter) = TimeStepPlan(TimeStepPlan_Counter - 1).OriginXPositionNextfL0(guard_counter)
            OriginYPositionM(guard_counter) = TimeStepPlan(TimeStepPlan_Counter - 1).OriginYPositionNextfL0(guard_counter)
            EmergencyVerifierM(guard_counter) = TimeStepPlan(TimeStepPlan_Counter - 1).EmergencyVerifierNextfL0(guard_counter)
            StartingTaskM(guard_counter) = TimeStepPlan(TimeStepPlan_Counter - 1).StartingTaskNextfL0(guard_counter)
            SimulationXPositionM(guard_counter) = TimeStepPlan(TimeStepPlan_Counter - 1).SimulationXPositionNextfL0(guard_counter)
            SimulationYPositionM(guard_counter) = TimeStepPlan(TimeStepPlan_Counter - 1).SimulationYPositionNextfL0(guard_counter)
            LiberationTimeM(guard_counter) = TimeStepPlan(TimeStepPlan_Counter - 1).LiberationTimeNextfL0(guard_counter)
        Next guard_counter
    
        '3.1.6 Create New Plans Set
        Set TimeStepPlan(TimeStepPlan_Counter) = New CTimeStepPlanSet
    
        '3.1.7 Modify Prevs Parameters according to Nexts
        Call TimeStepPlan(TimeStepPlan_Counter).InitializeParameters(OriginXPositionM(), OriginYPositionM(), EmergencyVerifierM(), StartingTaskM(), SimulationXPositionM(), SimulationYPositionM(), LiberationTimeM())

        '3.1.8 Update Task Arrays
        '3.1.8.1 Get Accomplished TasksArrays
        
        
        NumTaskininterval = TimeStepPlan(TimeStepPlan_Counter - 1).numexectaskininterval
        
        If NumTaskininterval > 0 Then
        
        If TimeStepPlan_Counter > 1 Then
        ReDim OverallAccomplishedTasks(1 To NumTaskininterval)
            For i = 1 To NumTaskininterval
                OverallAccomplishedTasks(i) = TimeStepPlan(TimeStepPlan_Counter - 1).UsedTasksArrayf(i)
            Next i
        Else
        End If
    
        '3.1.8.3 Eliminate Tasks accomplished from Arrays
          
          
          If TimeStepPlan_Counter > 1 Then
            'Sweep through accomplished Arrays
            For i = 1 To NumTaskininterval
                For j = 1 To UBound(AvailableTasksID())
                    If OverallAccomplishedTasks(i) = AvailableTasksID(j) Then
                        'Check if it is the last one
                        If j = UBound(AvailableTasksID()) Then
                            ReDim Preserve AvailableTasksID(UBound(AvailableTasksID()) - 1)
                        Else
                            'If not use cut and paste procedure
                            For k = j To (UBound(AvailableTasksID()) - 1)
                                AvailableTasksID(k) = AvailableTasksID(k + 1)
                            Next k
                            ReDim Preserve AvailableTasksID(UBound(AvailableTasksID()) - 1)
                        End If
                        Exit For
                    Else
                    End If
                
                Next j
            Next i
        Else
        End If
    
        Else
        End If
        
        '3.1.9 Add Current Alarm Task ID
        
        
        ReDim Preserve AvailableTasksID(UBound(AvailableTasksID()) + 1)
        
        AvailableTasksID(UBound(AvailableTasksID())) = alarm_counter
    
        '3.1.10 Build Plans
        Call TimeStepPlan(TimeStepPlan_Counter).ConstructNewPlans(StartVirtualTime, FinishVirtualTime, VirtualTimeStep, StandardRadius, EmergencyDuration, AllGuardsID(), AvailableTasksID())
    
        '3.1.11 Publish History
        Sheets("Results").Select
        HistoryRow = HistoryRow + 1
        Cells(10 + HistoryRow, 2) = CurrentAlarmTime
        Cells(10 + HistoryRow, 3) = TimeStepPlan(TimeStepPlan_Counter).SelectedIteration
        Cells(10 + HistoryRow, 4) = TimeStepPlan(TimeStepPlan_Counter).SelectedTopScore
        Cells(10 + HistoryRow, 5) = TimeStepPlan(TimeStepPlan_Counter).NormSelectedTopScore
        Cells(10 + HistoryRow, 6) = TimeStepPlan(TimeStepPlan_Counter).SelectedCoverage
        Cells(10 + HistoryRow, 7) = TimeStepPlan(TimeStepPlan_Counter).SelectedCombinedScore

        '3.1.12 Accumulate Summary Statistics (ONE PREVIOUS)
        RealCummulativeReward = RealCummulativeReward + TimeStepPlan(TimeStepPlan_Counter - 1).CurrentTOPScoreCollected
        
        RealCummulativeRewardNormal = RealCummulativeRewardNormal + TimeStepPlan(TimeStepPlan_Counter - 1).CurrentTOPScoreCollectedNormal
        RealCummulativeRewardAlarms = RealCummulativeRewardAlarms + TimeStepPlan(TimeStepPlan_Counter - 1).CurrentAlarmScoreCollected
        
        RealCummulativeCoverage = RealCummulativeCoverage + TimeStepPlan(TimeStepPlan_Counter - 1).CurrentCoverageCollectedRaw

        LastGuardRow = TimeStepPlan(TimeStepPlan_Counter - 1).LastGuardRowP

    Next alarm_counter
Else
End If



'4. Account for Last Leg (No alarms until the end of shift)
'4.1 Check PrevAlarmTime parameter
If TimeStepPlan_Counter > 1 Then
    LastGuardRow = TimeStepPlan(TimeStepPlan_Counter - 1).LastGuardRowP
Else
    LastGuardRow = 10
End If

If TimeStepPlan_Counter > 1 Then
    PrevAlarmTime = Task(alarm_counter - 1).Releasing
Else
    PrevAlarmTime = 0
End If

CurrentAlarmTime = TerminationTime

'4.2 Collect Final Status Parameters


Call TimeStepPlan(TimeStepPlan_Counter).PlanStatusVerificationLastLeg(PrevAlarmTime, CurrentAlarmTime, VirtualTimeStep, LastGuardRow)

'4.3 Accumulate Summary Statistics
RealCummulativeRewardNormal = RealCummulativeRewardNormal + TimeStepPlan(TimeStepPlan_Counter).CurrentTOPScoreCollectedNormal
RealCummulativeRewardAlarms = RealCummulativeRewardAlarms + TimeStepPlan(TimeStepPlan_Counter).CurrentAlarmScoreCollected
RealCummulativeReward = RealCummulativeReward + TimeStepPlan(TimeStepPlan_Counter).CurrentTOPScoreCollected
RealCummulativeCoverage = RealCummulativeCoverage + TimeStepPlan(TimeStepPlan_Counter).CurrentCoverageCollectedRaw
NumberofSampleIntervals = Int((TerminationTime - 0.00001) / VirtualTimeStep) + 1
AverageCummulativeCoverage = RealCummulativeCoverage / Int((TerminationTime - EmergencyDuration - MinDistanceAlarm - 0.000001) / VirtualTimeStep)


end_time = timer
t = end_time - start_time



'4.4 Collect maximum Possible
Sheets("Results").Select
MaximumPossibleTopScore = Range("f3").Value
NormalizedTopScore = RealCummulativeReward / MaximumPossibleTopScore

'4.4 Publish Results
MaximumPossibleScore = Cells(3, 6)
Cells(4, 6) = RealCummulativeReward
Cells(4, 7) = t


If MaximumPossibleScore - MaxNormalTopScore = 0 Then
    Cells(4, 10) = 0
Else
    Cells(4, 10) = (RealCummulativeRewardAlarms) / (MaximumPossibleScore - MaxNormalTopScore)
End If



Cells(5, 6) = NormalizedTopScore

Cells(4, 12) = RealCummulativeRewardNormal
Cells(4, 13) = RealCummulativeRewardAlarms


Cells(6, 6) = AverageCummulativeCoverage

Application.ScreenUpdating = True

End Sub
