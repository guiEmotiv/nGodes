VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CGuardTemptativePlan"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'Declare Variables for Attributes
Private m_TemptativePlanEntries As Collection
Private m_TemptativePlanEntry As CTemptativePlanEntry
Private m_Profit As Single
Private m_GuardIterationFeasibility As Boolean
Private m_LastTask As Integer
Private m_StopIteration As Boolean
Private m_RecentSelectedTask As Integer
Private m_NextFastSearch As Integer
'notice actual position, is only for tracking path purposes in displaying coverage
Private m_ActualPositionX As Single
Private m_ActualPositionY As Single
'the next three parameters are required for starting simulation
Private m_LiberationTimePrev As Single
Private m_LiberationTimeNext As Single
Private m_SimulationXPositionPrev As Single
Private m_SimulationYPositionPrev As Single
Private m_SimulationXPositionNext As Single
Private m_SimulationYPositionNext As Single
Private xxx As Single


'accomplished tasks array
Private m_AccomplishedTasksArray() As Single
'last task counted
Private m_LastTaskCounted As Single
'only for locating vehicles
Private m_OriginXPositionPrev As Single
Private m_OriginYPositionPrev As Single
Private m_EmergencyVerifierPrev As Boolean
Private m_StartingTaskPrev As Single
Private m_OriginXPositionNext As Single
Private m_OriginYPositionNext As Single
Private m_EmergencyVerifierNext As Single
Private m_StartingTaskNext As Single


Property Get TemptativePlanEntries() As Collection
TemptativePlanEntries = m_TemptativePlanEntries
End Property
Property Get Profit() As Single
Profit = m_Profit
End Property
Property Get GuardIterationFeasibility() As Boolean
GuardIterationFeasibility = m_GuardIterationFeasibility
End Property
Property Get LastTask() As Integer
LastTask = m_LastTask
End Property
Property Get StopIteration() As Integer
StopIteration = m_StopIteration
End Property
Property Get RecentSelectedTask() As Integer
RecentSelectedTask = m_RecentSelectedTask
End Property
Property Get NextFastSearch() As Integer
NextFastSearch = m_NextFastSearch
End Property
Property Get LiberationTimePrev() As Single
LiberationTimePrev = m_LiberationTimePrev
End Property
Property Let LiberationTimePrev(LTPV As Single)
m_LiberationTimePrev = LTPV
End Property
Property Get LiberationTimeNext() As Single
LiberationTimeNext = m_LiberationTimeNext
End Property

Property Get SimulationXPositionPrev() As Single
SimulationXPositionPrev = m_SimulationXPositionPrev
End Property
Property Let SimulationXPositionPrev(SXPP As Single)
m_SimulationXPositionPrev = SXPP
End Property
Property Get SimulationYPositionPrev() As Single
SimulationYPositionPrev = m_SimulationYPositionPrev
End Property
Property Let SimulationYPositionPrev(SYPP As Single)
m_SimulationYPositionPrev = SYPP
End Property
Property Get SimulationXPositionNext() As Single
SimulationXPositionNext = m_SimulationXPositionNext
End Property

Property Get SimulationYPositionNext() As Single
SimulationYPositionNext = m_SimulationYPositionNext
End Property

Property Get AccomplishedTasksArray(var_TaskCounter As Integer) As Single
AccomplishedTasksArray = m_AccomplishedTasksArray(var_TaskCounter)
End Property
Public Function AccomplishedTasksArrayf(var_TaskCounter As Integer) As Integer
AccomplishedTasksArrayf = m_AccomplishedTasksArray(var_TaskCounter)
End Function
Property Get LastTaskCounted() As Integer
LastTaskCounted = m_LastTaskCounted
End Property
Property Get OriginXPositionPrev() As Single
OriginXPositionPrev = m_OriginXPositionPrev
End Property
Property Let OriginXPositionPrev(OXPV As Single)
m_OriginXPositionPrev = OXPV
End Property

Property Get OriginYPositionPrev() As Single
OriginYPositionPrev = m_OriginYPositionPrev
End Property
Property Let OriginYPositionPrev(OYPV As Single)
m_OriginYPositionPrev = OYPV
End Property

Property Get EmergencyVerifierPrev() As Boolean
EmergencyVerifierPrev = m_EmergencyVerifierPrev
End Property
Property Let EmergencyVerifierPrev(EVP As Boolean)
m_EmergencyVerifierPrev = EVP
End Property

Property Get StartingTaskPrev() As Single
StartingTaskPrev = m_StartingTaskPrev
End Property
Property Let StartingTaskPrev(STP As Single)
m_StartingTaskPrev = STP
End Property

Property Get OriginXPositionNext() As Single
OriginXPositionNext = m_OriginXPositionNext
End Property
Property Get OriginYPositionNext() As Single
OriginYPositionNext = m_OriginYPositionNext
End Property

Property Get EmergencyVerifierNext() As Boolean
EmergencyVerifierNext = m_EmergencyVerifierNext
End Property

Property Get StartingTaskNext() As Single
StartingTaskNext = m_StartingTaskNext
End Property



Public Sub Class_Initialize()

Dim m_TemptativePlanEntry As CTemptativePlanEntry

ReDim m_AccomplishedTasksArray(0 To 2)

'Set profit guards' route to zero
m_Profit = 0
m_GuardIterationFeasibility = True
m_LastTask = 1
m_StopIteration = False
m_RecentSelectedTask = -1
m_NextFastSearch = 1

m_LiberationTimePrev = Task(0).Releasing
m_LiberationTimeNext = Task(0).Releasing
m_SimulationXPositionPrev = Site(0).XCoordinate
m_SimulationYPositionPrev = Site(0).YCoordinate
m_SimulationXPositionNext = Site(0).XCoordinate
m_SimulationYPositionNext = Site(0).YCoordinate

m_OriginXPositionPrev = Site(0).XCoordinate
m_OriginYPositionPrev = Site(0).YCoordinate
m_EmergencyVerifierPrev = False
m_StartingTaskPrev = Task(0).Releasing

m_OriginXPositionNext = Site(0).XCoordinate
m_OriginYPositionNext = Site(0).YCoordinate
m_EmergencyVerifierNext = False
m_StartingTaskNext = Task(0).Releasing

'###m_FirstTaskinSequence = True
m_AccomplishedTasksArray(0) = 0
m_AccomplishedTasksArray(1) = 0
m_AccomplishedTasksArray(2) = 0
m_LastTaskCounted = 1

'create new plan entry and one new plan entry for the collection
Set m_TemptativePlanEntries = New Collection
    Set m_TemptativePlanEntry = New CTemptativePlanEntry
    With m_TemptativePlanEntry
    'basically, identifies artificial task 0 in the base
        .IDTemptativePlanTask = 0
        .TemptativePlanFinishTaskExec = 0
        'adds to collection
        m_TemptativePlanEntries.Add Item:=m_TemptativePlanEntry
   End With
End Sub
Public Sub ConsiderTemptativePlans(StartVirtualTimeL1 As Single, IDAVTask() As Integer)
'Considers an array of possible tasks to be included


'O. Declarations
Dim LastExecTime As Single
Dim LastTaskID As Integer
Dim SiteAdressOld As Integer
Dim XAdressOld  As Single
Dim YAdressOld As Single
Dim ConsideredTaskID As Integer
Dim XAdressConsidered As Single
Dim YAdressConsidered As Single
Dim ConsideredEarliest As Single
Dim ConsideredLatest As Single
Dim ConsideredDuration As Single
Dim ConsideredDistance As Double
Dim XBase As Single
Dim YBase As Single
Dim DistancetoBase As Double
Dim ConsideredStartExecTime As Single
Dim Criteria2 As Boolean
Dim WeightConsidered As Single
Dim TimeSinceConsidered As Single
Dim DesirabilityScore As Double
Dim FeasibleTaskID() As Integer
Dim FeasibleScore() As Single
Dim CumSum() As Single
Dim BestArrayScore() As Single
Dim BestArrayID() As Integer
Dim SelectedIDTask As Integer
Dim SelectedTaskEarliest As Single
Dim SelectedTaskDuration As Single
Dim NewTravelTime As Single
Dim ArrivalNewTime As Single
Dim TrueIndicator As Integer
Dim BestPosition As Integer
Dim BestPositionNow As Integer
Dim selector As Single
Dim min_pos As Integer
Dim minimum As Single
Dim goodcount As Integer
Dim XAdressSelected As Single
Dim YAdressSelected As Single
Dim k As Integer
Dim j As Integer
Dim z As Integer
Dim SmoothedWeight As Single

Dim TopBest As Single


'new
Dim SelectedIDSite As Integer

'1. Initialize variables,Feasible evaluates if task considered is feasible
'IterationFeasibility for identifying if there are feasible tasks,
'Trueindicator for identifying the number of feasible tasks


'assume by default that the guard iteration is infeasible
m_GuardIterationFeasibility = False
'No feasible tasks at first
TrueIndicator = 0
'first feasible task added in first position
min_pos = 1
'so that first feasible task is always added
minimum = -1
k = 1
BestPosition = 4
BestPositionNow = 0
'set fast search to one
m_NextFastSearch = 1

'2. Check the feasibility of including each available task
'in a guard's route

For j = 1 To UBound(IDAVTask)

    '2.1 Get information
    
        'get last execution time
        If m_LastTask > 1 Then
            LastExecTime = m_TemptativePlanEntries.Item(m_LastTask).TemptativePlanFinishTaskExec
        Else
        
        'IMPORTANT ADDITION, if it is the first task to be added this time, but only MAX
            If m_LiberationTimePrev > CurrentAlarmTime + 0.0001 Then
                LastExecTime = m_LiberationTimePrev
            Else
                LastExecTime = CurrentAlarmTime
            End If
        
        End If
        
        
        'get last task id
        LastTaskID = m_TemptativePlanEntries.Item(m_LastTask).IDTemptativePlanTask

        'get site adress of last task ID
        SiteAdressOld = Task(LastTaskID).IDSite

        'get x/y adress of last task ID,if m_lastTask=1 then coordinates must be ACTUAL coordinates
        If m_LastTask > 1 Then
            XAdressOld = Site(SiteAdressOld).XCoordinate
            YAdressOld = Site(SiteAdressOld).YCoordinate
        Else
        'IMPORTANT ADDITION
            XAdressOld = m_SimulationXPositionPrev
            YAdressOld = m_SimulationYPositionPrev
        End If

        'get x/y coordinate of task considered
        ConsideredTaskID = Task(IDAVTask(j)).IDSite
        XAdressConsidered = Site(ConsideredTaskID).XCoordinate
        YAdressConsidered = Site(ConsideredTaskID).YCoordinate

        'get earliest of task considered
        ConsideredEarliest = Task(IDAVTask(j)).Earliest

        'get latest of task considered
        ConsideredLatest = Task(IDAVTask(j)).Latest

        'get duration of last task considered
        ConsideredDuration = Task(IDAVTask(j)).Duration

        'get transfer time of last task considered
        ConsideredDistance = ((XAdressConsidered - XAdressOld) ^ 2 + _
        (YAdressConsidered - YAdressOld) ^ 2) ^ 0.5

        'get arrival time
        If LastExecTime + ConsideredDistance < ConsideredEarliest Then
            ConsideredStartExecTime = ConsideredEarliest
        Else
            ConsideredStartExecTime = LastExecTime + ConsideredDistance
        End If

        'get x/y coordinates of base site
        XBase = Site(0).XCoordinate
        YBase = Site(0).YCoordinate

        'get distance to base
        DistancetoBase = ((XBase - XAdressConsidered) ^ 2 + _
        (YBase - YAdressConsidered) ^ 2) ^ 0.5

        'Criteria2: Finish before end of shift/return to base
        If BaseReturn = True Then
            If ConsideredStartExecTime <= TerminationTime - DistancetoBase - ConsideredDuration Then
                Criteria2 = True
            Else
                Criteria2 = False
            End If
        Else
            If ConsideredStartExecTime <= TerminationTime - ConsideredDuration Then
                Criteria2 = True
            Else
                Criteria2 = False
            End If
        End If
        
        
    '2.2 Decide feasibility Criteria1: Start new task on time, & Criteria2
    
        If LastExecTime + ConsideredDistance < ConsideredLatest And _
            Criteria2 = True Then
            
            '2.2.1 save in feasible array id, and pertinent score
                
                'get weight of task
                WeightConsidered = Task(IDAVTask(j)).Importance
    
               
                
    
                'calculate time since last task
                TimeSinceConsidered = ConsideredStartExecTime + ConsideredDuration - LastExecTime
                
               
                
               
                
                'calculate if option smoothed is on
                 'get smoothed weight
                If RunMode = 4 Then
                    SmoothedWeight = Exp(-(MeanRateAlarmsperShift / TerminationTime) * (ConsideredStartExecTime - StartVirtualTimeL1))
                    DesirabilityScore = ((WeightConsidered * SmoothedWeight) / TimeSinceConsidered) ^ 3
                Else
                    If UBound(IDAVTask) > 9 Then
                        xxx = Rnd
                        
                        If xxx > 0.5 Then
                            DesirabilityScore = (TimeSinceConsidered / (100 / 12)) ^ 3
                        Else
                            'calculate desirability score
                            DesirabilityScore = (WeightConsidered / TimeSinceConsidered) ^ 3
                        End If
                        
                    Else
                            DesirabilityScore = (WeightConsidered / TimeSinceConsidered) ^ 3
                      
                    End If
                End If
                
                'save j in feasible array with score,
                'redim arrays preserving values
                ReDim Preserve FeasibleTaskID(k)
                ReDim Preserve FeasibleScore(k)
                FeasibleTaskID(k) = IDAVTask(j)
                FeasibleScore(k) = DesirabilityScore
                
                'Increase TrueIndicator to see if no tasks can be added
                TrueIndicator = TrueIndicator + 1
                k = k + 1
            Else
                     
        End If
    
Next j

'3. Select and add new task if possible
If UBound(IDAVTask) > 10 Then
    TopBest = 6
Else
    TopBest = 4
End If


'Verify if no task was considered as Feasible,
'then proceeed selecting four best tasks
If TrueIndicator > 0 Then

    '3.1 The guard iteration is then sucseeful
    m_GuardIterationFeasibility = True
    
    '3.2 Calculate maximum dimension of array
    If TrueIndicator < TopBest Then
        BestPosition = TrueIndicator
    Else
        BestPosition = TopBest
    End If
    
    If BestPosition = 0 Then
    'MsgBox "Bestposition is zero"
    End If
    
    k = 1
    '3.3 Redim arrays without preserving values
    ReDim BestArrayScore(TrueIndicator)
    ReDim BestArrayID(TrueIndicator)
    
    
   '3.4 Identify four best tasks
    For i = 1 To TrueIndicator
        If FeasibleScore(i) > minimum Then
            BestArrayScore(min_pos) = FeasibleScore(i)
            BestArrayID(min_pos) = FeasibleTaskID(i)
            min_pos = min_pos + 1
            'indentify best saved scores so far
            If i < BestPosition Then
                BestPositionNow = i
            Else
                BestPositionNow = BestPosition
            End If
            'identify least score
            For z = 1 To BestPositionNow
                'the first time change minimum,else compare
                If i = 1 Then
                    minimum = BestArrayScore(min_pos - 1)
                Else
                    If BestArrayScore(z) < minimum Then
                        minimum = BestArrayScore(min_pos - 1)
                    Else
                    End If
                End If
            Next z
        Else
        End If
    Next i
        
    
    '3.5 Add scores
    'Initialize cummulative sum
    ReDim CumSum(0 To BestPosition)
    
    CumSum(0) = 0
    
    For goodcount = 1 To BestPosition
        CumSum(goodcount) = CumSum(goodcount - 1) + BestArrayScore(goodcount)
    Next goodcount


    '3.6 Select new task to include in plan
    Randomize
    selector = Rnd
        If CumSum(BestPosition) = 0 Then
            SelectedIDTask = BestArrayID(1)
        Else
            For goodcount = 1 To BestPosition
                If selector < CumSum(goodcount) / CumSum(BestPosition) Then
                    SelectedIDTask = BestArrayID(goodcount)
                    Exit For
                Else
                End If
            Next goodcount
        End If
        
    
    '3.7 Calculate elapsed time
        'get data
        SelectedTaskDuration = Task(SelectedIDTask).Duration
        SelectedTaskEarliest = Task(SelectedIDTask).Earliest
        SelectedIDSite = Task(SelectedIDTask).IDSite
        
        'get travel dataIMPORTANT
        XAdressSelected = Site(SelectedIDSite).XCoordinate
        YAdressSelected = Site(SelectedIDSite).YCoordinate
        NewTravelTime = ((XAdressSelected - XAdressOld) ^ 2 + _
        (YAdressSelected - YAdressOld) ^ 2) ^ 0.5
        
        'get arrival time
        If LastExecTime + NewTravelTime < SelectedTaskEarliest Then
            ArrivalNewTime = SelectedTaskEarliest
        Else
            ArrivalNewTime = LastExecTime + NewTravelTime
        End If
     
        LastExecTime = ArrivalNewTime + SelectedTaskDuration
   

    
    '3.8b when option smoothed is on
    
    If RunMode = 4 Then
        SmoothedWeight = Exp(-(MeanRateAlarmsperShift / TerminationTime) * (ArrivalNewTime - StartVirtualTimeL1))
        m_Profit = m_Profit + (Task(SelectedIDTask).Importance * SmoothedWeight)
    Else
    '3.8 Calculate CummulativeProfit/Update LastTask counter property
    m_Profit = m_Profit + Task(SelectedIDTask).Importance
    End If
    
     m_LastTask = m_LastTask + 1
     
    '3.9 EXECUTE Call Add method selected task to plan important
    Call Add(SelectedIDTask, LastExecTime)
    'MsgBox "SelectedTaskID" & SelectedIDTask
    
    '3.10 Pass property to delete task from availability array
    m_RecentSelectedTask = SelectedIDTask
    
    
    '3.11 If o task will remain
    If UBound(IDAVTask) = 1 Then
        m_StopIteration = True
    Else
    End If
    
Else

    '3.11 Guard Iteration failed
    m_GuardIterationFeasibility = False
    m_RecentSelectedTask = -1
End If
   

End Sub

Public Sub Add(SelectedIDTask As Integer, LastExecTime As Single)

Set m_TemptativePlanEntry = New CTemptativePlanEntry
With m_TemptativePlanEntry
    .IDTemptativePlanTask = SelectedIDTask
    .TemptativePlanFinishTaskExec = LastExecTime
    m_TemptativePlanEntries.Add Item:=m_TemptativePlanEntry
End With
End Sub


Public Function RetrieveStatus(VirtualTime As Single) As Variant

'0. Variables Declaration
Dim LastPlanTask As Integer
Dim FastSearch As Integer
Dim PreviousPlanTask As Integer
Dim PreviousPlanTaskID As Integer
Dim NextPlanTaskID As Integer
Dim PreviousPlanSiteID As Integer
Dim NextPlanSiteID As Integer
Dim PreviousFinishPlanTask As Single
Dim NextFinishPlanTask As Single
Dim XPreviousPlanCoordinate As Single
Dim YPreviousPlanCoordinate As Single
Dim XNextPlanCoordinate As Single
Dim YNextPlanCoordinate As Single
Dim DistancetoNextSite As Single
Dim PreviousPlanReleaseTime As Single
Dim NextPlanReleaseTime As Single
Dim NextPlanDuration  As Single
Dim NextPlanEarliest As Single
Dim VirtualArrivalTimeP As Single
Dim VirtualArrivalTime As Single
Dim VirtualStartTime As Single
Dim VirtualFinishTime As Single
Dim ActualXCoordinate As Single
Dim ActualYCoordinate As Single
Dim CoverageRadius As Single
Dim PCoverageRadius As Single
Dim PassingArray() As Variant
Dim status As String
Dim LastFinishPlanTask As Single
Dim XPlanCoordinate As Single
Dim YPlanCoordinate As Single
Dim Distancetobase2 As Single
Dim LastPlanTaskID As Integer
Dim LastPlanSiteID As Integer
Dim XLastPlanCoordinate As Single
Dim YLastPlanCoordinate As Single

Dim PreviousTransferDistance As Single

Dim BaseX As Single
Dim BaseY As Single

'Retrieve last times and fast search
LastPlanTask = m_LastTask
FastSearch = m_NextFastSearch
VirtualStartTime = 0
VirtualFinishTime = 0

'dont forget to the exception of beginning tasks

'PART ONE: INTERMEDIATE TASKS
'1. Search which task interval is involved /(-1) so that the next can be included
If LastPlanTask > 1 Then
'check if empty
For PreviousPlanTask = FastSearch To LastPlanTask - 1

    'Verify if FastSearch is in fact the first search
    If PreviousPlanTask > 1 Then
    'Is NOT the first search
        'Obtain the TaskID's of the previous and next involved
        PreviousPlanTaskID = m_TemptativePlanEntries.Item(PreviousPlanTask).IDTemptativePlanTask
        NextPlanTaskID = m_TemptativePlanEntries.Item(PreviousPlanTask + 1).IDTemptativePlanTask
        'MsgBox NextPlanTaskID & "NPlanID"
    
        'Obtain finishing servicing times for involved intervals
        PreviousFinishPlanTask = m_TemptativePlanEntries.Item(PreviousPlanTask).TemptativePlanFinishTaskExec
        NextFinishPlanTask = m_TemptativePlanEntries.Item(PreviousPlanTask + 1).TemptativePlanFinishTaskExec
    
        'Obtain VirtualFinishTime
        VirtualFinishTime = NextFinishPlanTask
        
        'Is it within the interval?
        If VirtualTime > PreviousFinishPlanTask And VirtualTime <= NextFinishPlanTask Then
    
            'Obtain site ID's for involved intervals
            PreviousPlanSiteID = Task(PreviousPlanTaskID).IDSite
            NextPlanSiteID = Task(NextPlanTaskID).IDSite
    
            'Obtain coordinates and distances between consecutive sites in the plan
            XPreviousPlanCoordinate = Site(PreviousPlanSiteID).XCoordinate
            YPreviousPlanCoordinate = Site(PreviousPlanSiteID).YCoordinate
            XNextPlanCoordinate = Site(NextPlanSiteID).XCoordinate
            YNextPlanCoordinate = Site(NextPlanSiteID).YCoordinate
            DistancetoNextSite = ((XNextPlanCoordinate - XPreviousPlanCoordinate) ^ 2 + (YNextPlanCoordinate - YPreviousPlanCoordinate) ^ 2) ^ 0.5

            'Obtain release times (only next needed)
            NextPlanReleaseTime = Task(NextPlanTaskID).Releasing
    
            'Obtain duration
            NextPlanDuration = Task(NextPlanTaskID).Duration
    
            'Obtain earliest time
            NextPlanEarliest = Task(NextPlanTaskID).Earliest
    
            'Calculate Arrival Times
            VirtualArrivalTime = DistancetoNextSite + PreviousFinishPlanTask
            
            'Calculate Starting Time
            If VirtualArrivalTime < NextPlanEarliest Then
                VirtualStartTime = NextPlanEarliest
            Else
                VirtualStartTime = VirtualArrivalTime
            End If
    
    
            'IMPORTANT: UPDATE FAST SEARCH!!!!!
            m_NextFastSearch = PreviousPlanTask
            'MsgBox "NewTask " & m_NextFastSearch
        
        
            Select Case VirtualTime
        
            Case Is < VirtualArrivalTime
                'Avoid zero division
                If DistancetoNextSite = 0 Then
                    ActualXCoordinate = XNextPlanCoordinate
                    ActualXCoordinate = YNextPlanCoordinate
                Else
                    ActualXCoordinate = ((VirtualTime - PreviousFinishPlanTask) / DistancetoNextSite) * (XNextPlanCoordinate - XPreviousPlanCoordinate) + XPreviousPlanCoordinate
                    ActualYCoordinate = ((VirtualTime - PreviousFinishPlanTask) / DistancetoNextSite) * (YNextPlanCoordinate - YPreviousPlanCoordinate) + YPreviousPlanCoordinate
                End If
            If NextPlanReleaseTime > 0 Then
                PCoverageRadius = StandardRadius - (NextFinishPlanTask - VirtualTime)
                If PCoverageRadius > 0 Then
                    CoverageRadius = PCoverageRadius
                Else
                    CoverageRadius = 0
                End If
                'Status 1 means "Travel Emergency"
                status = "Travel Emergency " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
            Else
                CoverageRadius = StandardRadius
                'Status 2 means "TravelOrdinary"
                status = "Travel Ordinary " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
            End If
            
            Case Is < VirtualStartTime
                ActualXCoordinate = XNextPlanCoordinate
                ActualYCoordinate = YNextPlanCoordinate
                CoverageRadius = StandardRadius
                'Status 3 means "WaitOrdinary"
                status = "Waiting Ordinary " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
            
            Case Is <= VirtualFinishTime
                ActualXCoordinate = XNextPlanCoordinate
                ActualYCoordinate = YNextPlanCoordinate
                CoverageRadius = StandardRadius - (NextFinishPlanTask - VirtualTime)
                'Status 4 means "Wait Servicing"
                If NextPlanReleaseTime = 0 Then
                    status = "Serving Ordinary " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
                Else
                    status = "Serving Emergency " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
                End If
            
            End Select
            'MsgBox CoverageRadius & "CovRad"
            Exit For
        Else
        
        End If
    Else
        'Is the FIRST search, refer to previous?
    
        'Obtain the TaskID's of the previous and next involved
        'previous taskID not needed, already fulfilled by x's and y's
        NextPlanTaskID = m_TemptativePlanEntries.Item(PreviousPlanTask + 1).IDTemptativePlanTask
        'MsgBox NextPlanTaskID & "NPlanID"
        
        
        'Obtain finishing servicing times for involved intervals
        If m_LiberationTimePrev > CurrentAlarmTime + 0.0001 Then
               PreviousFinishPlanTask = m_LiberationTimePrev
        Else
               PreviousFinishPlanTask = CurrentAlarmTime
        End If
        
        NextFinishPlanTask = m_TemptativePlanEntries.Item(PreviousPlanTask + 1).TemptativePlanFinishTaskExec
    
        'Obtain VirtualFinishTime
        VirtualFinishTime = NextFinishPlanTask
    
        'Is it in interval?
        If VirtualTime > PreviousFinishPlanTask And VirtualTime <= NextFinishPlanTask Then
    
            'Obtain site ID's for involved intervals
            'previous not required, already stored in X and Y
            NextPlanSiteID = Task(NextPlanTaskID).IDSite
    
            'Obtain coordinates and distances between consecutive sites in the plan
            XPreviousPlanCoordinate = m_SimulationXPositionPrev
            YPreviousPlanCoordinate = m_SimulationYPositionPrev
            XNextPlanCoordinate = Site(NextPlanSiteID).XCoordinate
            YNextPlanCoordinate = Site(NextPlanSiteID).YCoordinate
            DistancetoNextSite = ((XNextPlanCoordinate - XPreviousPlanCoordinate) ^ 2 + (YNextPlanCoordinate - YPreviousPlanCoordinate) ^ 2) ^ 0.5
    
            'Obtain duration
            NextPlanDuration = Task(NextPlanTaskID).Duration
    
            'Obtain earliest time
            NextPlanEarliest = Task(NextPlanTaskID).Earliest
    
            'Obtain release times (only next needed)
            NextPlanReleaseTime = Task(NextPlanTaskID).Releasing
            
            'Calculate Arrival Times
            VirtualArrivalTime = DistancetoNextSite + PreviousFinishPlanTask
            
            'Calculate starting times
            If VirtualArrivalTime < NextPlanEarliest Then
                VirtualStartTime = NextPlanEarliest
            Else
                VirtualStartTime = VirtualArrivalTime
            End If
            
            
            'IMPORTANT: update fast search, it must be 1 still
            m_NextFastSearch = 1
            'MsgBox "NewTask " & m_NextFastSearch
            Select Case VirtualTime
        
            Case Is < VirtualArrivalTime
                'Avoid zero division
                If DistancetoNextSite = 0 Then
                    ActualXCoordinate = XNextPlanCoordinate
                    ActualXCoordinate = YNextPlanCoordinate
                Else
                    ActualXCoordinate = ((VirtualTime - PreviousFinishPlanTask) / DistancetoNextSite) * (XNextPlanCoordinate - XPreviousPlanCoordinate) + XPreviousPlanCoordinate
                    ActualYCoordinate = ((VirtualTime - PreviousFinishPlanTask) / DistancetoNextSite) * (YNextPlanCoordinate - YPreviousPlanCoordinate) + YPreviousPlanCoordinate
                End If
            If NextPlanReleaseTime > 0 Then
                PCoverageRadius = StandardRadius - (NextFinishPlanTask - VirtualTime)
                If PCoverageRadius > 0 Then
                    CoverageRadius = PCoverageRadius
                Else
                    CoverageRadius = 0
                End If
                'Status 1 means "Travel Emergency"
                status = "Travel Emergencyf " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
            Else
                CoverageRadius = StandardRadius
                'Status 2 means "TravelOrdinary"
                status = "Travel Ordinaryf " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
            End If
            
            Case Is < VirtualStartTime
                ActualXCoordinate = XNextPlanCoordinate
                ActualYCoordinate = YNextPlanCoordinate
                CoverageRadius = StandardRadius
                'Status 3 means "WaitOrdinary"
                status = "Wait Ordinaryf " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
            
            Case Is <= VirtualFinishTime
                ActualXCoordinate = XNextPlanCoordinate
                ActualYCoordinate = YNextPlanCoordinate
                CoverageRadius = StandardRadius - (NextFinishPlanTask - VirtualTime)
                'Status 4 means "Wait Servicing"
                If NextPlanReleaseTime = 0 Then
                    status = "Serving Ordinaryf " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
                Else
                    status = "Serving Emergencyf " & "Task " & NextPlanTaskID & "Site" & NextPlanSiteID
                End If
            End Select
            
            'Exit
            Exit For
            
        Else
            'IMPORTANT: This means that the time MAY BE BEFORE the protected time or is at a later state
            'Case 8: Emergency Travelling, Case 9: Emergency Duration Case 10: Ordinary Duration
        
            'Case 8: Emergency Travelling
            If m_EmergencyVerifierPrev = True And VirtualTime <= m_StartingTaskPrev Then
                PreviousTransferDistance = ((m_SimulationXPositionPrev - m_OriginXPositionPrev) ^ 2 + (m_SimulationYPositionPrev - m_OriginYPositionPrev) ^ 2) ^ 0.5
                ActualXCoordinate = ((m_SimulationXPositionPrev - m_OriginXPositionPrev) * ((PreviousTransferDistance - m_StartingTaskPrev + VirtualTime) / PreviousTransferDistance)) + m_OriginXPositionPrev
                ActualYCoordinate = ((m_SimulationYPositionPrev - m_OriginYPositionPrev) * ((PreviousTransferDistance - m_StartingTaskPrev + VirtualTime) / PreviousTransferDistance)) + m_OriginYPositionPrev
                
                
                
                CoverageRadius = StandardRadius - (m_LiberationTimePrev - VirtualTime)
                status = "Travelling Emergencyp"
                'IMPORTANT: update fast search, it must be 1 still
                m_NextFastSearch = 1
                Exit For
            Else
            End If
        
            'Case 9: Emergency Duration
            If m_EmergencyVerifierPrev = True And VirtualTime > m_StartingTaskPrev And VirtualTime <= NextFinishPlanTask Then
                ActualXCoordinate = m_SimulationXPositionPrev
                ActualYCoordinate = m_SimulationYPositionPrev
                CoverageRadius = StandardRadius - (m_LiberationTimePrev - VirtualTime)
                status = "Serving Emergencyp"
                'IMPORTANT: update fast search, it must be 1 still
                m_NextFastSearch = 1
                Exit For
            End If
        
            'Case 10: Ordinary Duration
            If m_EmergencyVerifierPrev = False And VirtualTime <= m_LiberationTimePrev Then
                ActualXCoordinate = m_SimulationXPositionPrev
                ActualYCoordinate = m_SimulationYPositionPrev
                CoverageRadius = StandardRadius - (m_LiberationTimePrev - VirtualTime)
                status = "Serving Ordinaryp"
                'IMPORTANT: update fast search, it must be 1 still
                m_NextFastSearch = 1
                Exit For
            Else
            End If
            
            'If VirtualTime >= NextFinishPlanTask Then
            'IMPORTANT: UPDATE FAST SEARCH!!!!!
            'm_NextFastSearch = PreviousPlanTask
            'Else
            'End If
            
            'Exit
           
        End If
        
    End If
 Next PreviousPlanTask
Else
'no tasks in stack, so where is it?

    'Important: Alarm occured BEFORE protected time, then Tracking record of previous finish
    'Case 8: Emergency Travelling, Case 9: Emergency Duration Case 10: Ordinary Duration
        
    'Case 8: Emergency Travelling
    If m_EmergencyVerifierPrev = True And VirtualTime < m_StartingTaskPrev Then
        PreviousTransferDistance = ((m_SimulationXPositionPrev - m_OriginXPositionPrev) ^ 2 + (m_SimulationYPositionPrev - m_OriginYPositionPrev) ^ 2) ^ 0.5
        ActualXCoordinate = ((m_SimulationXPositionPrev - m_OriginXPositionPrev) * ((PreviousTransferDistance - m_StartingTaskPrev + VirtualTime) / PreviousTransferDistance)) + m_OriginXPositionPrev
        ActualYCoordinate = ((m_SimulationYPositionPrev - m_OriginYPositionPrev) * ((PreviousTransferDistance - m_StartingTaskPrev + VirtualTime) / PreviousTransferDistance)) + m_OriginYPositionPrev
        CoverageRadius = StandardRadius - (m_LiberationTimePrev - VirtualTime)
        status = "Travelling Emergencyp1"
    Else
    End If
        
    'Case 9: Emergency Duration
    If m_EmergencyVerifierPrev = True And VirtualTime > m_StartingTaskPrev Then
        ActualXCoordinate = m_SimulationXPositionPrev
        ActualYCoordinate = m_SimulationYPositionPrev
        CoverageRadius = StandardRadius - (m_LiberationTimePrev - VirtualTime)
        status = "Serving Emergencyp1"
    End If
        
    'Case 10: Ordinary Duration
    If m_EmergencyVerifierPrev = False And VirtualTime <= m_LiberationTimePrev Then
        ActualXCoordinate = m_SimulationXPositionPrev
        ActualYCoordinate = m_SimulationYPositionPrev
        CoverageRadius = StandardRadius - (m_LiberationTimePrev - VirtualTime)
        status = "Serving Durationp1"
    Else
    End If

End If


'PART TWO: Last Leg

If m_LastTask = 1 Then
'is first part, thus get data from protected time parameters
    
    'Returning to base
    If VirtualTime >= m_LiberationTimePrev And BaseReturn = True Then
    
         
        BaseX = Site(0).XCoordinate
        BaseY = Site(0).YCoordinate
    
        'Coordinate of last task
        XLastPlanCoordinate = m_SimulationXPositionPrev
        YLastPlanCoordinate = m_SimulationYPositionPrev
        
        'Calulate distance to base (with ref2)
        Distancetobase2 = ((BaseX - XLastPlanCoordinate) ^ 2 + (BaseY - YLastPlanCoordinate) ^ 2) ^ 0.5
         
        
        'Note that liberation time should be the current virtual time
        If VirtualTime < Distancetobase2 + m_LiberationTimePrev Then
            'travelling
            ActualXCoordinate = (((VirtualTime - m_LiberationTimePrev) / Distancetobase2) * (BaseX - XLastPlanCoordinate)) + XLastPlanCoordinate
            ActualYCoordinate = (((VirtualTime - m_LiberationTimePrev) / Distancetobase2) * (BaseY - YLastPlanCoordinate)) + YLastPlanCoordinate
            CoverageRadius = StandardRadius
            status = "Return to Basep"
        Else
            'at base
            ActualXCoordinate = BaseX
            ActualYCoordinate = BaseY
            CoverageRadius = StandardRadius
            status = "At Basep"
        End If
    
    Else
    End If
    
    'Returning to last task
    If VirtualTime >= m_LiberationTimePrev And BaseReturn = False Then
    
        'Only coordinates needed
        'Obtain coordinates and distances between consecutive sites in the plan
        XLastPlanCoordinate = m_SimulationXPositionPrev
        YLastPlanCoordinate = m_SimulationXPositionPrev
    
        ActualXCoordinate = XLastPlanCoordinate
        ActualYCoordinate = YLastPlanCoordinate
        CoverageRadius = StandardRadius
        status = 7 'waiting at the last base
    
    Else
    End If
    
    
Else
'is not first task, data has to be obtained from last task
     
    'Obtain the TaskID's of LastPlanTask
    LastPlanTaskID = m_TemptativePlanEntries.Item(LastPlanTask).IDTemptativePlanTask
    
    
    'Obtain finishing servicing times for involved intervals
    LastFinishPlanTask = m_TemptativePlanEntries.Item(LastPlanTask).TemptativePlanFinishTaskExec
  
    'Returning to base
    If VirtualTime >= LastFinishPlanTask And BaseReturn = True Then
    
        'Obtain site ID's for involved intervals
        LastPlanSiteID = Task(LastPlanTaskID).IDSite
        
        'Obtain coordinates and distances between consecutive sites in the plan
        PreviousPlanSiteID = Task(LastPlanSiteID).IDSite
    
        XLastPlanCoordinate = Site(PreviousPlanSiteID).XCoordinate
        YLastPlanCoordinate = Site(PreviousPlanSiteID).YCoordinate
        
        BaseX = Site(0).XCoordinate
        BaseY = Site(0).YCoordinate
        
        'Calculate distance to base (with ref2)
        Distancetobase2 = ((BaseX - XLastPlanCoordinate) ^ 2 + (BaseY - YLastPlanCoordinate) ^ 2) ^ 0.5
    
        
        If VirtualTime < Distancetobase2 + LastFinishPlanTask Then
            'travelling to base
            ActualXCoordinate = (((VirtualTime - LastFinishPlanTask) / Distancetobase2) * (BaseX - XLastPlanCoordinate)) + XLastPlanCoordinate
            ActualYCoordinate = (((VirtualTime - LastFinishPlanTask) / Distancetobase2) * (BaseY - YLastPlanCoordinate)) + YLastPlanCoordinate
            CoverageRadius = StandardRadius
            status = "Return to Base"
        Else
            'at base
            ActualXCoordinate = BaseX
            ActualYCoordinate = BaseY
            CoverageRadius = StandardRadius
            status = "At Base"
        End If

    Else
    End If
    
    'Stay in last task
    If VirtualTime >= LastFinishPlanTask And BaseReturn = False Then
        'Obtain site ID's for involved intervals
        LastPlanSiteID = Task(LastPlanTaskID).IDSite
    
        'Obtain coordinates and distances between consecutive sites in the plan
        XLastPlanCoordinate = Site(LastPlanSiteID).XCoordinate
        YLastPlanCoordinate = Site(LastPlanSiteID).YCoordinate
    
        ActualXCoordinate = XLastPlanCoordinate
        ActualYCoordinate = YLastPlanCoordinate
        CoverageRadius = StandardRadius
        status = 7 'waiting at the last base
    Else
    End If
    
End If

'If VirtualTime > 20 And NextPlanTaskID = 22 Then
'MsgBox "error"
'Else
'End If




ReDim PassingArray(0 To 3)


PassingArray = Array(ActualXCoordinate, ActualYCoordinate, CoverageRadius, status)
RetrieveStatus = PassingArray

End Function

Public Function LeftOver() As Single

'Calculates time left to finish tasks
Dim FastSearchL As Integer
Dim CurrentPlanTaskID As Integer
Dim DurationTaskID As Integer
Dim TaskLeft As Integer
Dim LastPlanTask As Integer

FastSearchL = m_NextFastSearch + 1
'Notice that m_LastTask is the number of tasks in the plan

For TaskLeft = FastSearchL To m_LastTask

    CurrentPlanTaskID = m_TemptativePlanEntries.Item(TaskLeft).IDTemptativePlanTask
    'CurrentPlanTaskID
    'MsgBox CurrentPlanTaskID & "CurrentTaskID"
    DurationTaskID = Task(CurrentPlanTaskID).Duration
    LeftOver = LeftOver + DurationTaskID
Next TaskLeft
End Function

Public Sub PrintPlan(guard_counter)
Dim entry As Integer
Dim q As Integer



For entry = 1 To m_LastTask
q = m_TemptativePlanEntries.Item(entry).IDTemptativePlanTask
'MsgBox "Guard" & guard_counter & "Task ID " & q
Next entry
End Sub


Public Sub PlanStatusVerificationL2(CurrentAlarmTime As Single)

'Declarations
Dim TaskSearch_Counter As Integer
Dim StoppingCriteria As Boolean
Dim ProbExecTaskID As Integer
Dim ProbTimeExecTaskFinish As Single


Dim ProbExecTaskDuration As Single
Dim ProbExecTaskEarliest As Single
Dim ProbExecTaskSiteID As Single
Dim ProbExecTaskSiteX As Single
Dim ProbExecTaskSiteY As Single

'previous, interrupted before accomplishing any task
Dim ProbExecPrevTaskID As Integer
Dim ProbExecPrevTaskSiteX As Single
Dim ProbExecPrevTaskSiteY As Single
Dim ProbTimeExecPrevTaskFinish As Single
Dim ProbExecPrevTaskSiteID As Single

Dim ReleaseTimeTask As Single
Dim IsEmergencyTask As Boolean

Dim DistancePrevCurExecTask As Single
Dim ArrivalTimeProbTask As Single
Dim StartingTimeProbTask As Single

Dim TaskSearchCounter As Integer


Dim BaseX As Single
Dim BaseY As Single
Dim ReturnToBaseTime As Single
Dim DistanceReturnBase As Single

StoppingCriteria = False

TaskSearchCounter = 2

'1. Check TaskSearchCounter> m_LastTask. if yes then no task in array
If TaskSearchCounter > m_LastTask Then
'then there are no scheduled tasks in this interval OR returning to base or staying in base
        
    'obtain previous planned finished time
    ProbTimeExecPrevTaskFinish = m_LiberationTimePrev
    
    'obtain task adress
    ProbExecPrevTaskSiteX = m_SimulationXPositionPrev
    ProbExecPrevTaskSiteY = m_SimulationYPositionPrev
                
    'Set common parameters
    m_OriginXPositionNext = m_OriginXPositionPrev
    m_OriginYPositionNext = m_OriginYPositionPrev
    m_EmergencyVerifierNext = m_EmergencyVerifierPrev
    m_LiberationTimeNext = CurrentAlarmTime
    m_StartingTaskNext = m_StartingTaskPrev
   
   'Check if protected time has passed
   'Doing something else from PREVIOUS TASK
   If CurrentAlarmTime < m_LiberationTimePrev Then
    m_LiberationTimeNext = m_LiberationTimePrev
    m_SimulationXPositionNext = m_SimulationXPositionPrev
    m_SimulationYPositionNext = m_SimulationYPositionPrev
    
    Else
        'Ask if return to base or not
        If BaseReturn = True Then
             m_LiberationTimeNext = CurrentAlarmTime
            'obtain base adress
            BaseX = Site(0).XCoordinate
            BaseY = Site(0).YCoordinate
                
            DistanceReturnBase = ((ProbExecPrevTaskSiteX - BaseX) ^ 2 + (ProbExecPrevTaskSiteY - BaseY) ^ 2) ^ 0.5
                    
            ReturnToBaseTime = DistanceReturnBase + ProbTimeExecPrevTaskFinish
           
                    
            'Check if already arrived to base
            If CurrentAlarmTime < ReturnToBaseTime Then
                'En-route to base
                m_SimulationXPositionNext = ((BaseX - ProbExecPrevTaskSiteX) * (CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistanceReturnBase) + ProbExecPrevTaskSiteX
                m_SimulationYPositionNext = ((BaseY - ProbExecPrevTaskSiteY) * (CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistanceReturnBase) + ProbExecPrevTaskSiteY
            Else
                'In base
                m_SimulationXPositionNext = BaseX
                m_SimulationYPositionNext = BaseY
            End If

        Else
            'The adress of last task
            m_SimulationXPositionNext = ProbExecPrevTaskSiteX
            m_SimulationYPositionNext = ProbExecPrevTaskSiteY
                                        
        End If
        
    m_AccomplishedTasksArray(TaskSearchCounter) = 0
    End If
    
Else
    'There are tasks scheduled in this interval
    Do While StoppingCriteria = False
        '1.1 Verify if last Task has been exceeded
        If TaskSearchCounter > m_LastTask Then
            
            'It has been exceeded, no more tasks to add, is in last leg
                    
            'obtain previous task ID
            ProbExecPrevTaskID = m_TemptativePlanEntries.Item(TaskSearchCounter - 1).IDTemptativePlanTask
                
            'obtain previous planned finished time
            ProbTimeExecPrevTaskFinish = m_TemptativePlanEntries.Item(TaskSearchCounter - 1).TemptativePlanFinishTaskExec
                
            'obtain previous task adress
            ProbExecPrevTaskSiteID = Task(ProbExecPrevTaskID).IDSite
            ProbExecPrevTaskSiteX = Site(ProbExecPrevTaskSiteID).XCoordinate
            ProbExecPrevTaskSiteY = Site(ProbExecPrevTaskSiteID).YCoordinate
                
            'Set common parameters
            m_LiberationTimeNext = CurrentAlarmTime
            m_EmergencyVerifierNext = False
            m_OriginXPositionNext = ProbExecPrevTaskSiteX
            m_OriginYPositionNext = ProbExecPrevTaskSiteY
                
                
            'Ask if return to base or not
            If BaseReturn = True Then
                
                'obtain base adress
                BaseX = Site(0).XCoordinate
                BaseY = Site(0).YCoordinate
                
                DistanceReturnBase = ((ProbExecPrevTaskSiteX - BaseX) ^ 2 + (ProbExecPrevTaskSiteY - BaseY) ^ 2) ^ 0.5
                    
                ReturnToBaseTime = DistanceReturnBase + ProbTimeExecPrevTaskFinish
                m_StartingTaskNext = ReturnToBaseTime
                    
                'Check if already arrived to base
                If CurrentAlarmTime < ReturnToBaseTime Then
                    'En-route to base
                    m_SimulationXPositionNext = ((BaseX - ProbExecPrevTaskSiteX) * (CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistanceReturnBase) + ProbExecPrevTaskSiteX
                    m_SimulationYPositionNext = ((BaseY - ProbExecPrevTaskSiteY) * (CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistanceReturnBase) + ProbExecPrevTaskSiteY
                Else
                    'In base
                    m_SimulationXPositionNext = BaseX
                    m_SimulationYPositionNext = BaseY
                End If
            Else
                'The adress of last task
                m_SimulationXPositionNext = ProbExecPrevTaskSiteX
                m_SimulationYPositionNext = ProbExecPrevTaskSiteY
                    
                    
                    
            End If
                    
                    
            Exit Do
        
        Else
            'It has not been exceeded, there are still tasks in the array
                
            'obtain task ID
            ProbExecTaskID = m_TemptativePlanEntries.Item(TaskSearchCounter).IDTemptativePlanTask
            'obtain planned finished time
            ProbTimeExecTaskFinish = m_TemptativePlanEntries.Item(TaskSearchCounter).TemptativePlanFinishTaskExec
            
            'Redim array to add tasks
            ReDim Preserve m_AccomplishedTasksArray(TaskSearchCounter)
                
            '1.2 Verify if the finishing time is AFTER the current time
            If ProbTimeExecTaskFinish < CurrentAlarmTime Then
                'Is BEFORE, Then add ton accomplished Tasks array
                m_AccomplishedTasksArray(TaskSearchCounter) = ProbExecTaskID
                    
            Else
                'Time has been exceeded, possibly last task (confirm)SO???, set also final parameters
                '1.3 Verify if it is the first task or not
                If TaskSearchCounter > 2 Then
                        
                    '1.4 It is not the first task,  retrieve previous data from previous task
                        
                    '(1.4) obtain previous task ID
                    ProbExecPrevTaskID = m_TemptativePlanEntries.Item(TaskSearchCounter - 1).IDTemptativePlanTask
                    ProbTimeExecPrevTaskFinish = m_TemptativePlanEntries.Item(TaskSearchCounter - 1).TemptativePlanFinishTaskExec
        
                    '(1.4) duration of current task in consideration
                    ProbExecTaskDuration = Task(ProbExecTaskID).Duration
                    ProbExecTaskEarliest = Task(ProbExecTaskID).Earliest
        
                    '(1.4) X,Y of current task in consideration
                    ProbExecTaskSiteID = Task(ProbExecTaskID).IDSite
                    ProbExecTaskSiteX = Site(ProbExecTaskSiteID).XCoordinate
                    ProbExecTaskSiteY = Site(ProbExecTaskSiteID).YCoordinate
        
                    '(1.4) X,Y of previous task in consideration
                    ProbExecPrevTaskSiteID = Task(ProbExecPrevTaskID).IDSite
                    ProbExecPrevTaskSiteX = Site(ProbExecPrevTaskSiteID).XCoordinate
                    ProbExecPrevTaskSiteY = Site(ProbExecPrevTaskSiteID).YCoordinate
        
                    '(1.4) get release time of task in consideration,identify if emergency
                    ReleaseTimeTask = Task(ProbExecTaskID).Releasing
                    If ReleaseTimeTask > 0 Then
                        IsEmergencyTask = True
                    Else
                        IsEmergencyTask = False
                    End If
        
                    '(1.4) get distance
                    DistancePrevCurExecTask = ((ProbExecPrevTaskSiteX - ProbExecTaskSiteX) ^ 2 + (ProbExecPrevTaskSiteY - ProbExecTaskSiteY) ^ 2) ^ 0.5
        
        
                    '(1.4) get arrival time
                    ArrivalTimeProbTask = DistancePrevCurExecTask + ProbTimeExecPrevTaskFinish
        
                    '(1.4) get starting time at task in consideration
                    If ArrivalTimeProbTask < ProbExecTaskEarliest Then
                        StartingTimeProbTask = ProbExecTaskEarliest
                    Else
                        StartingTimeProbTask = ArrivalTimeProbTask
                    End If
        
                    '(1.4) Cases, Case 1 Transfering 1a ordinary-1b emergency, Case 2 Wainting Odinary, Case 3 Duration Ordinary/Emergency, Case 4 Emergency
    
                    Select Case CurrentAlarmTime
        
                    '(1.4) transferring
                    Case Is <= ArrivalTimeProbTask
                        'if ordinary then allowed to interrupt, if alarm then it can not be interrupted
                        If IsEmergencyTask = False Then
                            m_OriginXPositionNext = ProbExecPrevTaskSiteX
                            m_OriginYPositionNext = ProbExecPrevTaskSiteY
                            m_EmergencyVerifierNext = False
                            m_StartingTaskNext = StartingTimeProbTask
                            'Avoid division by zero
                            If DistancePrevCurExecTask = 0 Then
                                m_SimulationXPositionNext = ProbExecPrevTaskSiteX
                            Else
                                m_SimulationXPositionNext = (ProbExecTaskSiteX - ProbExecPrevTaskSiteX) * ((CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistancePrevCurExecTask) + ProbExecPrevTaskSiteX
                                m_SimulationYPositionNext = (ProbExecTaskSiteY - ProbExecPrevTaskSiteY) * ((CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistancePrevCurExecTask) + ProbExecPrevTaskSiteY
                            End If
                            m_LiberationTimeNext = CurrentAlarmTime
                            m_AccomplishedTasksArray(TaskSearchCounter) = 0
                        Else
                            'if emergency then wait until task accomplished
                            m_OriginXPositionNext = ProbExecPrevTaskSiteX
                            m_OriginYPositionNext = ProbExecPrevTaskSiteY
                            m_EmergencyVerifierNext = True
                            m_StartingTaskNext = StartingTimeProbTask
                            m_SimulationXPositionNext = ProbExecTaskSiteX
                            m_SimulationYPositionNext = ProbExecTaskSiteY
                            m_LiberationTimeNext = ProbTimeExecTaskFinish
                            m_AccomplishedTasksArray(TaskSearchCounter) = ProbExecTaskID
                        End If
                    '(1.4) waiting ordinary
                    Case Is < StartingTimeProbTask
                        'only applies for ordinary tasks, waiting for starting time window
                        If IsEmergencyTask = False Then
                            m_OriginXPositionNext = ProbExecPrevTaskSiteX
                            m_OriginYPositionNext = ProbExecPrevTaskSiteY
                            m_EmergencyVerifierNext = False
                            m_StartingTaskNext = StartingTimeProbTask
                            m_SimulationXPositionNext = ProbExecTaskSiteX
                            m_SimulationYPositionNext = ProbExecTaskSiteY
                            m_LiberationTimeNext = CurrentAlarmTime
                            m_AccomplishedTasksArray(TaskSearchCounter) = 0
                        Else
                        MsgBox "error"
                        End If
                        
                    '(1.4)during duration (same for ordinary and emergency tasks)
                    Case Is < ProbTimeExecTaskFinish
                        m_OriginXPositionNext = ProbExecPrevTaskSiteX
                        m_OriginYPositionNext = ProbExecPrevTaskSiteY
                        m_EmergencyVerifierNext = IsEmergencyTask
                        m_StartingTaskNext = StartingTimeProbTask
                        m_SimulationXPositionNext = ProbExecTaskSiteX
                        m_SimulationYPositionNext = ProbExecTaskSiteY
                        m_LiberationTimeNext = ProbTimeExecTaskFinish
                        m_AccomplishedTasksArray(TaskSearchCounter) = ProbExecTaskID
                    End Select
                        
                      
                        
                        
                Else
                    '1.5 It is the FIRST task, data has to be obtained from protection parameters
                    'Take care for coordinates of previous task, and finishing time of previous task
                        
                    '(1.5)duration of current task in consideration
                    ProbExecTaskDuration = Task(ProbExecTaskID).Duration
                    ProbExecTaskEarliest = Task(ProbExecTaskID).Earliest
            
                    '(1.5) X,Y of current task in consideration
                    ProbExecTaskSiteID = Task(ProbExecTaskID).IDSite
                    ProbExecTaskSiteX = Site(ProbExecTaskSiteID).XCoordinate
                    ProbExecTaskSiteY = Site(ProbExecTaskSiteID).YCoordinate
                
                    '(1.5) IMPORTANT TAKE CARE HERE X,Y of previous task in consideration
                    ProbExecPrevTaskSiteX = m_SimulationXPositionPrev
                    ProbExecPrevTaskSiteY = m_SimulationYPositionPrev
            
                    '(1.5) TAKE HERE TOO.. previous finish execution time of task
                    ProbTimeExecPrevTaskFinish = m_LiberationTimePrev
            
                    '(1.5) get release time of task in consideration,identify if emergency
                    ReleaseTimeTask = Task(ProbExecTaskID).Releasing
                    If ReleaseTimeTask > 0 Then
                        IsEmergencyTask = True
                    Else
                        IsEmergencyTask = False
                    End If
        
                    '(1.5) get distance
                    DistancePrevCurExecTask = ((ProbExecPrevTaskSiteX - ProbExecTaskSiteX) ^ 2 + (ProbExecPrevTaskSiteY - ProbExecTaskSiteY) ^ 2) ^ 0.5
        
                    '(1.5) get arrival time
                    ArrivalTimeProbTask = DistancePrevCurExecTask + ProbTimeExecPrevTaskFinish
        
                    '(1.5) get starting time at task in consideration
                    If ArrivalTimeProbTask < ProbExecTaskEarliest Then
                        StartingTimeProbTask = ProbExecTaskEarliest
                    Else
                        StartingTimeProbTask = ArrivalTimeProbTask
                    End If
            
                    '(1.5) Cases, Case 1 Transfering 1a ordinary-1b emergency, Case 2 Wainting Odinary, Case 3 Duration Ordinary/Emergency, Case 4 Emergency
            
                    Select Case CurrentAlarmTime
        
                    '(1.5)transferring
                    Case Is <= ArrivalTimeProbTask
                        'if ordinary then allowed to interrupt, if alarm then it can not be interrupted
                        If IsEmergencyTask = False Then
                            
                            m_OriginXPositionNext = ProbExecPrevTaskSiteX
                            m_OriginYPositionNext = ProbExecPrevTaskSiteY
                            m_EmergencyVerifierNext = False
                            m_StartingTaskNext = StartingTimeProbTask
                            
                            'Avoid division by zero
                            If DistancePrevCurExecTask = 0 Then
                                m_SimulationXPositionNext = ProbExecPrevTaskSiteX
                                m_SimulationYPositionNext = ProbExecPrevTaskSiteY
                            Else
                                m_SimulationXPositionNext = ((ProbExecTaskSiteX - ProbExecPrevTaskSiteX) * ((CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistancePrevCurExecTask)) + ProbExecPrevTaskSiteX
                                m_SimulationYPositionNext = ((ProbExecTaskSiteY - ProbExecPrevTaskSiteY) * ((CurrentAlarmTime - ProbTimeExecPrevTaskFinish) / DistancePrevCurExecTask)) + ProbExecPrevTaskSiteY
                            End If
                            
                            m_LiberationTimeNext = CurrentAlarmTime
                            m_AccomplishedTasksArray(TaskSearchCounter) = 0
                    
                        Else
                            
                            'if emergency then wait until task accomplished
                            m_OriginXPositionNext = ProbExecPrevTaskSiteX
                            m_OriginYPositionNext = ProbExecPrevTaskSiteY
                            m_EmergencyVerifierNext = True
                            m_StartingTaskNext = StartingTimeProbTask
                            m_SimulationXPositionNext = ProbExecTaskSiteX
                            m_SimulationYPositionNext = ProbExecTaskSiteY
                            m_LiberationTimeNext = ProbTimeExecTaskFinish
                            m_AccomplishedTasksArray(TaskSearchCounter) = ProbExecTaskID
                        
                        End If
                
                    '(1.5) waiting ordinary
                    Case Is < StartingTimeProbTask
                        'only applies for ordinary tasks, waiting for starting time window
                        If IsEmergencyTask = False Then
                        m_OriginXPositionNext = ProbExecPrevTaskSiteX
                        m_OriginYPositionNext = ProbExecPrevTaskSiteY
                        m_EmergencyVerifierNext = False
                        m_StartingTaskNext = StartingTimeProbTask
                        m_SimulationXPositionNext = ProbExecTaskSiteX
                        m_SimulationYPositionNext = ProbExecTaskSiteY
                        m_LiberationTimeNext = CurrentAlarmTime
                        m_AccomplishedTasksArray(TaskSearchCounter) = 0
                    Else
                    End If
                
                    '(1.5) during duration (same for ordinary and emergency tasks)
                    Case Is < ProbTimeExecTaskFinish
                        m_OriginXPositionNext = ProbExecPrevTaskSiteX
                        m_OriginYPositionNext = ProbExecPrevTaskSiteY
                        m_EmergencyVerifierNext = IsEmergencyTask
                        m_StartingTaskNext = StartingTimeProbTask
                        m_SimulationXPositionNext = ProbExecTaskSiteX
                        m_SimulationYPositionNext = ProbExecTaskSiteY
                        m_LiberationTimeNext = ProbTimeExecTaskFinish
                        m_AccomplishedTasksArray(TaskSearchCounter) = ProbExecTaskID
                    
                    End Select
                
                
                
                End If
                
                '(1.3)In any case the Set Stopping Criteria set to True
                StoppingCriteria = True
                
            End If
                
        End If
        
        m_LastTaskCounted = TaskSearchCounter
        TaskSearchCounter = TaskSearchCounter + 1
    

    Loop
            
End If

'If m_SimulationXPositionNext = 0 Or m_SimulationYPositionNext = 0 Then
'MsgBox "error"
'Else
'End If

'MsgBox "Origin PositionX " & m_OriginXPositionNext & " OriginPositionY " & m_OriginYPositionNext & " EmergencyVerifierNext" & m_EmergencyVerifierNext _
'& " Starting TaskNext" & m_StartingTaskNext & " SimulationXNext " & m_SimulationXPositionNext & " SimulationYNext " & m_SimulationYPositionNext _
'& " Liberation Time Next " & m_LiberationTimeNext
'& " Task " & m_AccomplishedTasksArray(TaskSearchCounter - 1)


End Sub



